class Routes::Preview < Bridgetown::Rack::Routes
  route do |r|
    r.on "preview" do
      # Route hit by the Prismic preview flow
      # route: /preview
      r.is do
        unless prismic_preview_token
          response.status = 403
          next prismic_token_error_msg
        end

        r.redirect prismic_preview_redirect_url
      end

      r.is "testconfig" do
        Bridgetown::Current.site.config.prismic_api.inspect
      end

      # Rendering pathway to preview a page
      # route: /preview/:custom_type/:id
      r.is String, String do |custom_type, id|
        unless prismic_preview_token
          response.status = 403
          next prismic_token_error_msg
        end

        save_prismic_preview_token

        Bridgetown::Model::Base
          .find("prismic://#{custom_type}/#{id}")
          .render_as_resource
          .output
      end
    end
  end
end
