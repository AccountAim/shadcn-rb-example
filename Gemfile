source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
end

group :development do
  gem "web-console"
  gem "foreman"
  # Generators-only, so `:development`. `:branch` is required by the dev-container local-gem override (see compose.yaml).
  gem "shadcn-rb", git: "https://github.com/AccountAim/shadcn-rb.git", branch: "main"
end

gem "tailwind_merge", "~> 1.4"

# Demo content deps: rouge for the codeblock component's syntax highlighting;
# method_source for the docs_helper's ERB source extraction.
gem "rouge", "~> 4.7"
gem "method_source", "~> 1.1"
