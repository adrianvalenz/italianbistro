class Page < Bridgetown::Model::Base
  class << self
    def collection_name = :pages
    def prismic_custom_type = :page
    def prismic_slug(doc) = doc.slug
    def prismic_url(doc)
      "/#{prismic_slug(doc)}"
    end
  end

  def self.process_prismic_document(doc)
    provide_data do
      id                doc.id
      slug from: ->     { prismic_slug(doc) }
      type              doc.type
      created_at        doc.first_publication_date

      layout            :page
      title             doc["page.title"]           .as_text
      content           doc["page.page_body"]       &.as_html with_links
    end
  end
end
