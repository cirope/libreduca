module ContentsHelper
  def document_file_identifier(document)
    document.file.identifier || document.file_identifier if document.file?
  end
end
