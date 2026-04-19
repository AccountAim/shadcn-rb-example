# frozen_string_literal: true

# Your application's local Builder subclass. Component installers append
# `include Shadcnrb::<Name>` to this file. You own it — edit it however
# you like.

class Shadcnrb::Builder < Shadcnrb::BaseBuilder
  # BEGIN generated component includes
  include Shadcnrb::Icon::Component
  include Shadcnrb::Alert::Component
  include Shadcnrb::Avatar::Component
  include Shadcnrb::Badge::Component
  include Shadcnrb::Breadcrumb::Component
  include Shadcnrb::Button::Component
  include Shadcnrb::ButtonGroup::Component
  include Shadcnrb::Card::Component
  include Shadcnrb::Checkbox::Component
  include Shadcnrb::Codeblock::Component
  include Shadcnrb::Collapsible::Component
  include Shadcnrb::Dialog::Component
  include Shadcnrb::Drawer::Component
  include Shadcnrb::DropdownMenu::Component
  include Shadcnrb::Empty::Component
  include Shadcnrb::Input::Component
  include Shadcnrb::Textarea::Component
  include Shadcnrb::RadioGroup::Component
  include Shadcnrb::Select::Component
  include Shadcnrb::FormField::Component
  include Shadcnrb::Label::Component
  include Shadcnrb::Layout::Component
  include Shadcnrb::Link::Component
  include Shadcnrb::NavigationMenu::Component
  include Shadcnrb::Progress::Component
  include Shadcnrb::Separator::Component
  include Shadcnrb::Sidebar::Component
  include Shadcnrb::Switch::Component
  include Shadcnrb::Table::Component
  include Shadcnrb::Tabs::Component
  include Shadcnrb::ThemeSwitcher::Component
  include Shadcnrb::Toast::Component
  include Shadcnrb::Typography::Component
  include Shadcnrb::HoverCard::Component
  include Shadcnrb::Tooltip::Component
  include Shadcnrb::Skeleton::Component
  # END generated component includes
end
