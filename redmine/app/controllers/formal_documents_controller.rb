class FormalDocumentsController < ApplicationController
  #encrypt_text      decrypt_text

  # GET /formal_documents
  #def index
  #  @formal_documents = FormalDocument.all
  #end

  # GET /formal_documents/1
  #def show
  #  set_formal_document
  #end

  # GET /formal_documents/to_normal Recupera o generar el pdf

#------------------------------------------------------------------

  def to_normal
    pre_to
   if  params[:issue_status]  == '4'
          @formal_document.generatetemp_pdf
           if @formal_document.existPdf?
           @formal_document.save
           sendPDF
           else
            send_file(PATH_404, :filename => '404.png', :disposition => 'inline', :type => "image/gif")
          end
  else
      if @formal_document.existPdf?
      sendPDF
      else
             @formal_document.generate_pdf
             if @formal_document.existPdf?
                 @formal_document.save
                 sendPDF
             else
              send_file(PATH_404, :filename => '404.png', :disposition => 'inline', :type => "image/gif")
             end
      end
   end
end

#--------------------------------------------------------------------


#  def to_normal
#    pre_to  
#    if @formal_document.existPdf?
#      sendPDF
#    else  
#      @formal_document.generate_pdf
#      if @formal_document.existPdf?
#        @formal_document.save
#        sendPDF
#      else
#        send_file(PATH_404, :filename => '404.png', :disposition => 'inline', :type => "image/gif")
#      end
#    end  
#  end
#--------------------------------------trazabilidad 2018 init ------
  def to_normal_trazabilidad
    pre_to_trazabilidad
    #if @formal_document.existPdf?
    #  sendPDF
   # else
      @formal_document.generate_trazabilidad_pdf
      if @formal_document.existPdf?
        @formal_document.save
        sendPDF
      else
        send_file(PATH_404, :filename => '404.png', :disposition => 'inline', :type => "image/gif")
      end
   # end
  end

#----------------------------------------trazabilidad 2018 fin


def valor
 $valor = params[:q]
end
def valor_end
 $valor_end = params[:q]
end

def tipo
 $tipo = params[:q]
end

def trackers_id
 $trackers_id = params[:q]
end

def user_id
 $user_id = params[:q]
end


 def to_normal_reporte
    pre_to_reporte
     @formal_document.generatereporte_pdf_reporte($valor, $valor_end,$trackers_id, $user_id)
#      @formal_document.generatereporte_pdf_reporte($valor, $valor_end,4)

      if @formal_document.existPdf?
        @formal_document.save
        sendPDF
      else
        send_file(PATH_404, :filename => '404.png', :disposition => 'inline', :type => "image/gif")
      end
   # end
  end

  # GET /formal_documents/to_signatured Recupera o genera el pdf Firmado
  def to_signatured
    pre_to
    if @author.signature.present?
      if @formal_document.existPdfSignatured?
        sendSignedPDF
      else
        if @formal_document.existPdf?
          @formal_document.sign(@author.signature)
          sendSignedPDF
        else  
          @formal_document.generate_pdf
          if @formal_document.existPdf?
            @formal_document.sign(@author.signature)
            sendSignedPDF
          else
            send_file(PATH_404, :filename => '404.png', :disposition => 'inline', :type => "image/gif")
          end
        end
      end
    else
      send_file(PATH_404, :filename => '404.png', :disposition => 'inline', :type => "image/gif")
    end
  end

  def sendSignedPDF
    send_file(@formal_document.pdf_signatured_path, :filename => 'FIRMADO_'+@formal_document.filename, :disposition => 'inline', :type => "application/pdf")
  end

  def sendPDF
    send_file(@formal_document.pdf_path, :filename => @formal_document.filename, :disposition => 'inline', :type => "application/pdf")
  end

  #def new
  #  @formal_document = FormalDocument.new
  #end

  # POST /formal_documents
  #def create
  #  @formal_document = FormalDocument.new(formal_document_params)
  #  if @formal_document.save
  #    redirect_to @formal_document, notice: 'Formal document was successfully created.'
  #  else
  #    render :new
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formal_document
      @formal_document = FormalDocument.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def formal_document_params
      params.require(:formal_document).permit(:issue_id, :journal_id, :content_html, :filename, :author_id, :is_signatured, :is_deleted, :deleted_user, :created_user)
    end

    def pre_to
      @log = Logger.new(STDOUT)
      result = false;
      @formal_document = FormalDocument.new
      @formal_document.issue_id = params[:issue_id]
      @formal_document.journal_id = params[:journal_id]
      @formal_document.defineFilename
      @formal_document.created_user = User.current.id      
      if @formal_document.journal_id > 0
        journal = Journal.find(@formal_document.journal_id)
        @formal_document.author_id = journal.user_id
      else
        issue = Issue.find(@formal_document.issue_id)
        @formal_document.author_id = issue.author_id
      end
      @author = User.find(@formal_document.author_id)
    end
#vcolcha reporte init
    def pre_to_reporte
      @log = Logger.new(STDOUT)
      result = false;
      @formal_document = FormalDocument.new
      @formal_document.issue_id = params[:issue_id]
      @formal_document.journal_id = params[:journal_id]
      @formal_document.defineFilename_reporte
      @formal_document.created_user = User.current.id
      if @formal_document.journal_id > 0
        journal = Journal.find(@formal_document.journal_id)
        @formal_document.author_id = journal.user_id
      else
        issue = Issue.find(@formal_document.issue_id)
        @formal_document.author_id = issue.author_id
      end
      @author = User.find(@formal_document.author_id)
    end

#vcolcha reporte  fin
#vcolcha trazabilidad init
    def pre_to_trazabilidad
      @log = Logger.new(STDOUT)
      result = false;
      @formal_document = FormalDocument.new
      @formal_document.issue_id = params[:issue_id]
      @formal_document.journal_id = params[:journal_id]
      @formal_document.defineFilename_trazabilidad
      @formal_document.created_user = User.current.id
      if @formal_document.journal_id > 0
        journal = Journal.find(@formal_document.journal_id)
        @formal_document.author_id = journal.user_id
      else
        issue = Issue.find(@formal_document.issue_id)
        @formal_document.author_id = issue.author_id
      end
      @author = User.find(@formal_document.author_id)
    end

#vcolcha trazabilidad  fin






end
