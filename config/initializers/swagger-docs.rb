Swagger::Docs::Config.register_apis(
  {
      "1.0" => {
          :api_file_path => "public/api/v1/",
          :base_path => "http://localhost:3000",
          :clean_directoy => true,
          :base_api_controller => ActionController::API,
          :attributes => {
              :info => {
                  "title" => "Swagger Demo",
                  "description" => "How Swagger works",
                  "contact" => "ajacs1104@gmail.com",
                  "license" => "Apache 2.0"
              }
          }
      }
  }
)