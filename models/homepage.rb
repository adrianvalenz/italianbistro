class Homepage < Bridgetown::Model::Base
  class << self
    def collection_name = :pages
    def prismic_custom_type = :homepage
    def prismic_slug(doc) = doc.slug
    def prismic_url(doc)
      "/"
    end
  end

  def self.process_prismic_document(doc)
    provide_data do
      id                doc.id
      slug from: ->     { prismic_slug(doc) }
      type              doc.type
      created_at        doc.first_publication_date

      layout            :home
      title             doc["homepage.title"]         .as_text
      content           doc["homepage.homepage_body"] &.as_html with_links
    end
  end
end
