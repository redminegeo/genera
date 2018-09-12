/* Redmine - project management software
   Copyright (C) 2006-2015  Jean-Philippe Lang */

function addFile(inputEl, file, eagerUpload) {
  password_type = $(inputEl).data('password-type');
  max_files = password_type ? 1 : 10;
  //alert('password-type: '+password_type+' -- max_files: '+max_files); //TEST @fjaneta

  if ($('#attachments_fields').children().length < max_files) {

    var attachmentId = addFile.nextAttachmentId++;

    var fileSpan = $('<span>', { id: 'attachments_' + attachmentId });

    if(password_type){
      fileSpan.append(
        $('<input>', { type: 'text', 'class': 'filename readonly', name: 'attachments[' + attachmentId + '][filename]', readonly: 'readonly'} ).val(file.name),
        $('<input>', { type: 'password', 'class': 'description', name: 'attachments[' + attachmentId + '][description]', maxlength: 20,minlength: 6,size: 25,required: true,id: 'password',placeholder: $(inputEl).data('password-placeholder') } ).toggle(!eagerUpload),
        $('<input>', { type: 'password', 'class': 'description', name: 'attachments[' + attachmentId + '][confirmation]', maxlength: 20,minlength: 6,size: 25,required: true,id: 'confirmation',placeholder: $(inputEl).data('confirmation-placeholder') } ).toggle(!eagerUpload),
        $('<a>&nbsp</a>').attr({ href: "#", 'class': 'remove-upload' }).click(removeFile).toggle(!eagerUpload)
      ).appendTo('#attachments_fields');
    }else{
      fileSpan.append(
        $('<input>', { type: 'text', 'class': 'filename readonly', name: 'attachments[' + attachmentId + '][filename]', readonly: 'readonly'} ).val(file.name),
        $('<input>', { type: 'text', 'class': 'description', name: 'attachments[' + attachmentId + '][description]', maxlength: 255, placeholder: $(inputEl).data('description-placeholder') } ).toggle(!eagerUpload),
        $('<a>&nbsp</a>').attr({ href: "#", 'class': 'remove-upload' }).click(removeFile).toggle(!eagerUpload)
      ).appendTo('#attachments_fields');
    }

    if(eagerUpload) {
      ajaxUpload(file, attachmentId, fileSpan, inputEl);
    }

    return attachmentId;
  }
  return null;
}

addFile.nextAttachmentId = 1;

function ajaxUpload(file, attachmentId, fileSpan, inputEl) {

  function onLoadstart(e) {
    fileSpan.removeClass('ajax-waiting');
    fileSpan.addClass('ajax-loading');
    $('input:submit', $(this).parents('form')).attr('disabled', 'disabled');
  }

  function onProgress(e) {
    if(e.lengthComputable) {
      this.progressbar( 'value', e.loaded * 100 / e.total );
    }
  }

  function actualUpload(file, attachmentId, fileSpan, inputEl) {

    ajaxUpload.uploading++;

    uploadBlob(file, $(inputEl).data('upload-path'), attachmentId, {
        loadstartEventHandler: onLoadstart.bind(progressSpan),
        progressEventHandler: onProgress.bind(progressSpan)
      })
      .done(function(result) {
        progressSpan.progressbar( 'value', 100 ).remove();
        fileSpan.find('input.description, a').css('display', 'inline-block');
      })
      .fail(function(result) {
        progressSpan.text(result.statusText);
      }).always(function() {
        ajaxUpload.uploading--;
        fileSpan.removeClass('ajax-loading');
        var form = fileSpan.parents('form');
        if (form.queue('upload').length == 0 && ajaxUpload.uploading == 0) {
          $('input:submit', form).removeAttr('disabled');
        }
        form.dequeue('upload');
      });
  }

  var progressSpan = $('<div>').insertAfter(fileSpan.find('input.filename'));
  progressSpan.progressbar();
  fileSpan.addClass('ajax-waiting');

  var maxSyncUpload = $(inputEl).data('max-concurrent-uploads');

  if(maxSyncUpload == null || maxSyncUpload <= 0 || ajaxUpload.uploading < maxSyncUpload)
    actualUpload(file, attachmentId, fileSpan, inputEl);
  else
    $(inputEl).parents('form').queue('upload', actualUpload.bind(this, file, attachmentId, fileSpan, inputEl));
}

ajaxUpload.uploading = 0;

function removeFile() {
  $(this).parent('span').remove();
  return false;
}

function uploadBlob(blob, uploadUrl, attachmentId, options) {

  var actualOptions = $.extend({
    loadstartEventHandler: $.noop,
    progressEventHandler: $.noop
  }, options);

  uploadUrl = uploadUrl + '?attachment_id=' + attachmentId;
  if (blob instanceof window.File) {
    uploadUrl += '&filename=' + encodeURIComponent(blob.name);
    uploadUrl += '&content_type=' + encodeURIComponent(blob.type);
  }

  return $.ajax(uploadUrl, {
    type: 'POST',
    contentType: 'application/octet-stream',
    beforeSend: function(jqXhr, settings) {
      jqXhr.setRequestHeader('Accept', 'application/js');
      // attach proper File object 
      settings.data = blob;
    },
    xhr: function() {
      var xhr = $.ajaxSettings.xhr();
      xhr.upload.onloadstart = actualOptions.loadstartEventHandler;
      xhr.upload.onprogress = actualOptions.progressEventHandler;
      return xhr;
    },
    data: blob,
    cache: false,
    processData: false
  });
}

function addInputFiles(inputEl) {
  var clearedFileInput = $(inputEl).clone().val('');
  if ($.ajaxSettings.xhr().upload && inputEl.files) {
    // upload files using ajax
    uploadAndAttachFiles(inputEl.files, inputEl);
    $(inputEl).remove();
  } else {
    // browser not supporting the file API, upload on form submission
    var attachmentId;
    var aFilename = inputEl.value.split(/\/|\\/);
    attachmentId = addFile(inputEl, { name: aFilename[ aFilename.length - 1 ] }, false);
    if (attachmentId) {
      $(inputEl).attr({ name: 'attachments[' + attachmentId + '][file]', style: 'display:none;' }).appendTo('#attachments_' + attachmentId);
    }
  }
  
  clearedFileInput.insertAfter('#attachments_fields');
}

function uploadAndAttachFiles(files, inputEl) {
  var maxFileSize = $(inputEl).data('max-file-size');
  var maxFileSizeExceeded = $(inputEl).data('max-file-size-message');

  var sizeExceeded = false;
  $.each(files, function() {
    if (this.size && maxFileSize != null && this.size > parseInt(maxFileSize)) {sizeExceeded=true;}
  });
  if (sizeExceeded) {
    window.alert(maxFileSizeExceeded);
  } else {
    $.each(files, function() {addFile(inputEl, this, true);});
  }
}

function handleFileDropEvent(e) {

  $(this).removeClass('fileover');
  blockEventPropagation(e);
  alert('Holaaa');
  if ($.inArray('Files', e.dataTransfer.types) > -1) {
    uploadAndAttachFiles(e.dataTransfer.files, $('input:file.file_selector'));
  }
}

function dragOverHandler(e) {
  $(this).addClass('fileover');
  blockEventPropagation(e);
}

function dragOutHandler(e) {
  $(this).removeClass('fileover');
  blockEventPropagation(e);
}

function setupFileDrop() {
  if (window.File && window.FileList && window.ProgressEvent && window.FormData) {

    $.event.fixHooks.drop = { props: [ 'dataTransfer' ] };

    $('form div.box').has('input:file').each(function() {
      $(this).on({
          dragover: dragOverHandler,
          dragleave: dragOutHandler,
          drop: handleFileDropEvent
      });
    });
  }
}

// @fjaneta ini
//Validacion de password de signature dentro de formularios de usuarios
function validate_password_for_User(){
  res = false;
  if(document.getElementById("password") && document.getElementById("confirmation")){
    if($('#password').length > 0 && $('#confirmation').length > 0){
      if($('#password').val() == $('#confirmation').val()){
        res = true;
      }else{
        alert('Las contrasenas de la firma electronica no coinciden .');
      }
    }else{
      alert('Por favor ingrese contrasena de la firma electronica o borrela.');
    }  
  }else{
    res = true;
  }
  return res;
}
//Validacion de password de signature dentro de formularios de attachments
function validate_password_for_Attachments(){
  res = false;
  inputs = document.getElementsByTagName("input");
  password='';confirmation='';

  for(var i=0; i<inputs.length; i++) {
    if(inputs[i].name.indexOf("description")>=0){
      password = inputs[i].id;
    }
    if(inputs[i].name.indexOf("confirmation")>=0){
      confirmation = inputs[i].id;
    }
  }

  if(document.getElementById(confirmation)){
    if($('#'+confirmation).val().length>0 && $('#'+password).val().length>0){
      if($('#'+confirmation).val() == $('#'+password).val()){
        res = true;
      }else{
        alert('Las contrasenas no coinciden.');
      }
    }else{
      alert('Por favor ingrese los valores requeridos');
    }
  }else{
    res = true;
  }
  return res;
}

// @fjaneta fin 

$(document).ready(setupFileDrop);
