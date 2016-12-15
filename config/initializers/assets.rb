# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  onsenui.js
  onsenui.css
  comments_smart_phone.js
  albums.css
  application_smart_phone.js
  application_smart_phone.css
  knockout_kotaren_custom.js
  kotaren_smart_phone.js
  onsen-css-components.css
)
