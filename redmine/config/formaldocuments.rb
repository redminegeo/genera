# coding: UTF-8
#============================================================+
# Begin       : 09-05-2017
#
# Description : Configracion para la generacion de documentos formales
#
# Author: @fjaneta
# License: LGPL 2.1 or later
# Credits: https://github.com/naitoh/rbpdf/blob/master/example/rails/app/controllers/example_common.rb
#============================================================+

PATH_FORMALDOCUMENTS="#{File.join(Rails.root, 'files','formaldocuments')}" 
PATH_FORMALDOCUMENTS_SIGNATUREDS="#{File.join(Rails.root, 'files','formaldocuments_signatureds')}"
PATH_SIGNATURE_BASE="#{File.join(Rails.root, 'files')}"
PATH_ERROR="#{File.join(Rails.root, 'public','error.png')}"
PATH_404="#{File.join(Rails.root, 'public','404.png')}"

PDF_PAGE_ORIENTATION='P'
PDF_UNIT='mm'
PDF_PAGE_FORMAT='A4'
PDF_CREATOR='SIIM'
PDF_AUTHOR='SIIM'
PDF_FONT_NAME_DATA='helvetica'
PDF_FONT_SIZE_DATA=11
PDF_FONT_MONOSPACED='courier'
PDF_MARGIN_HEADER=15
PDF_MARGIN_FOOTER=10
PDF_MARGIN_TOP=17
PDF_MARGIN_BOTTOM=25
PDF_MARGIN_LEFT=25
PDF_MARGIN_RIGHT=15
PDF_IMAGE_SCALE_RATIO=1.00

PDF_SUBJECT='GESTOR DOCUMENTAL'
PDF_KEYWORDS='SIIM, REDMINE, GESTOR DOCUMENTAL'

SIGN_METHOD='adbe.pkcs7.sha1'
SIGN_LOCATION='Milagro'
SIGN_CONTACT='fredyjaneta@outlook.com'
SIGN_REASON='GESTOR DOCUMENTAL'
SIGN_SUFFIX='_signed'

$l = {}
$l['a_meta_charset'] = 'UTF-8'
$l['a_meta_dir'] = 'ltr'
$l['a_meta_language'] = 'es' 
