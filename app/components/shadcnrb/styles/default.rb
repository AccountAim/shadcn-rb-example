# frozen_string_literal: true

# Resets every component back to its built-in `Style` — the "flip back"
# counterpart to named style modules like `Shadcnrb::Styles::Brutalist`.
# Walks the registry populated by `Shadcnrb::ComponentBase.included`.
module Shadcnrb
  module Styles
    module Default
      module_function

      def apply!
        Shadcnrb.component_modules.each do |component|
          parent = component.name.sub(/::Component\z/, "").safe_constantize
          component.style = parent.const_get(:Style).new
        end
      end
    end
  end
end
