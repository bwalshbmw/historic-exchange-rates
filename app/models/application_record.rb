# Default class which models will inherit from in the app.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
