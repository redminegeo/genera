require 'openssl' 
require 'origami'
require 'pdfkit'
include Origami
require(File.join(Rails.root, 'config','formaldocuments.rb'))


class FormalDocument < ActiveRecord::Base

  validates_presence_of :issue_id, :journal_id, :content_html, :filename,:author_id, :created_user

  def author
    User.find(self.author_id)
  end

  def created
    User.find(self.created_user)
  end

  # @fjaneta
  def sign(attachment)

    inputFile = File.join(PATH_FORMALDOCUMENTS_SIGNATUREDS,self.filename)
    path = File.join(PATH_SIGNATURE_BASE,attachment.disk_directory,attachment.disk_filename)
    pkcs = nil
    Thread.new { pkcs = OpenSSL::PKCS12.new(File.read(path), Redmine::Ciphering.decrypt_text(attachment.description)) }.join
    key = OpenSSL::PKey::RSA.new(pkcs.key.to_pem)
    cert = OpenSSL::X509::Certificate.new(pkcs.certificate.to_pem)

    #<p  style="TagFirmaDigital"></p> --este es el tag que debe estar en el html de la, es un tag medio pendejo, xq quiero que sea transparente(osea que no se vea) si el documento no tiene firma no va a aparecer nada.
    self.defineFilename
    result = ActiveRecord::Base.connection.execute("select * from fn_formaldocument_get_html("+self.issue_id.to_s+","+self.journal_id.to_s+")")
    if result.count > 0
      now = Time.now
      self.content_html = result[0]["fn_formaldocument_get_html"].sub! "<p  style=\"TagFirmaDigital\"></p>","<p style=\"font-size: x-small; color: #3366ff;\"><em>Firmado digitalmente por: #{author.firstname} #{author.lastname}<br />(DN): c=ec,o=bce,ou=eci,cn= #{author.firstname} #{author.lastname}<br />Fecha y hora oficial Ecuador: #{now.iso8601}<br /></em></p>"; #reemplazo lo primero q esta entre "" por lo segundo
      kit = PDFKit.new(self.content_html, :page_size => 'Letter', :footer_center => '[page] / [topage]',:footer_font_size => 8)
      kit.to_file(File.join(PATH_FORMALDOCUMENTS_SIGNATUREDS,self.filename).to_s)#guardo el pdf con el tag cambiado para poder cargarlo de nuevo desde el repositorio y firmarlo con el .p12
    end
    #inputFile = File.join(PATH_FORMALDOCUMENTS_SIGNATUREDS,self.filename)
    pdf = PDF.read(inputFile)
    page = pdf.get_page(1)

    text_annotation = Annotation::AppearanceStream.new
    text_annotation.Type = Origami::Name.new("XObject")
    text_annotation.Resources = Resources.new
    text_annotation.Resources.ProcSet = [Origami::Name.new("Text")]
    text_annotation.set_indirect(true)
    text_annotation.Matrix = [ 1, 0, 0, 1, 0, 0 ]
    text_annotation.BBox = [ 0, 0, 200, 50]
    signature_annotation = Annotation::Widget::Signature.new
    signature_annotation.Rect = Rectangle[:llx => 395.0, :lly => 772.0, :urx => 595.0, :ury => 706.0]#los tama�os de la hoja A4 en pixeles es: 595 x 842 segun google, pongo el recuadro de la firma en la esquina de abajo xq al ser el texto dinamico no sabemos donde mismo va la firma
    signature_annotation.F = Annotation::Flags::PRINT
    signature_annotation.set_normal_appearance(text_annotation)

    page.add_annotation(signature_annotation)
     pdf.sign(cert, key,
      :method => SIGN_METHOD,
      :annotation => signature_annotation,
      :location => SIGN_LOCATION,
      :contact => SIGN_CONTACT,
      :reason => SIGN_REASON
    )
    pdf.save(inputFile)
  end

    def generatetemp_pdf
    self.defineFilenametemp
    result = ActiveRecord::Base.connection.execute("select * from fn_formaldocument_get_html("+self.issue_id.to_s+","+self.journal_id.to_s+")")
    if result.count > 0
      self.content_html = result[0]["fn_formaldocument_get_html"]
      kit = PDFKit.new(self.content_html, :page_size => 'Letter', :footer_center => '[page] / [topage]',:footer_font_size => 8)
      kit.to_file(File.join(PATH_FORMALDOCUMENTS,self.filename).to_s)
    end
    existPdf?
  end

  def generate_pdf
    self.defineFilename
    result = ActiveRecord::Base.connection.execute("select * from fn_formaldocument_get_html("+self.issue_id.to_s+","+self.journal_id.to_s+")")
    if result.count > 0
      self.content_html = result[0]["fn_formaldocument_get_html"]
      kit = PDFKit.new(self.content_html, :page_size => 'Letter', :footer_center => '[page] / [topage]',:footer_font_size => 8)
      kit.to_file(File.join(PATH_FORMALDOCUMENTS,self.filename).to_s)
    end
    existPdf?
  end

  def existPdf?
    if File.exist?(File.join(PATH_FORMALDOCUMENTS,self.filename))
      true
    else
      false
    end
  end

def generatereporte_pdf_reporte(finit, fend, tipo,usuario)
    self.defineFilename_reporte
    result = ActiveRecord::Base.connection.execute("select * from fn_reporte_get_html('" + User.current.login + "','#{finit}','#{fend}','#{tipo}','#{usuario}')")
    if result.count > 0
      self.content_html = result[0]["fn_reporte_get_html"]
      kit = PDFKit.new(self.content_html, :page_size => 'Legal', :print_media_type => true, :footer_center => '[page] / [topage]',:footer_font_size => 8)
      kit.to_file(File.join(PATH_FORMALDOCUMENTS,self.filename).to_s)

        end
    existPdf?
  end


###################################recorrido trazabilidad   2018 

  def generate_trazabilidad_pdf
    self.defineFilename_trazabilidad
	result = ActiveRecord::Base.connection.execute("select * from fn_trazabilidad_get_html('" + User.current.login + "', "+self.issue_id.to_s+")")
    if result.count > 0
      self.content_html = result[0]["fn_trazabilidad_get_html"]
      kit = PDFKit.new(self.content_html, :page_size => 'Letter', :footer_center => '[page] / [topage]',:footer_font_size => 8)
      kit.to_file(File.join(PATH_FORMALDOCUMENTS,self.filename).to_s)
        end
    existPdf?
  end

################################ recorrido 2018 finnnnnnn



  def pdf_path
    File.join(PATH_FORMALDOCUMENTS,self.filename)
  end

  def pdf_signatured_path
    File.join(PATH_FORMALDOCUMENTS_SIGNATUREDS,self.filename)
  end

  def existPdfSignatured?
    if File.exist?(File.join(PATH_FORMALDOCUMENTS_SIGNATUREDS,self.filename))
      true
    else
      false
    end
  end

 def defineFilename_trazabilidad
    self.filename = self.issue_id.to_s + (self.journal_id > 0 ? '_tr'+self.journal_id.to_s+'tr'+'_traz.pdf' : '_r.pdf')
  end

 def defineFilenametemp
    self.filename = self.issue_id.to_s + (self.journal_id > 0 ? '_'+self.journal_id.to_s+'temp.pdf' : 'temp.pdf')
  end

  def defineFilename
    self.filename = self.issue_id.to_s + (self.journal_id > 0 ? '_'+self.journal_id.to_s+'.pdf' : '.pdf')
  end
  def defineFilename_reporte
    self.filename = self.issue_id.to_s + (self.journal_id > 0 ? '_r'+self.journal_id.to_s+'r'+'_r.pdf' : '_r.pdf')
  end
end
