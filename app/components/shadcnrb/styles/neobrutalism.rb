# frozen_string_literal: true

# Neobrutalist demo style. Hard edges, thick borders, offset shadows, loud
# colors — a different *look* built on the same markup.
#
#   Shadcnrb::Style.apply(:neobrutalism)   # flip the look
#   Shadcnrb::Style.reset                  # flip back
#
# Covers every visual component (collapsible is structural-only, no look).

module Shadcnrb
  module Styles
    module Neobrutalism
      class Button < Shadcnrb::Button::Style
        def base
          "inline-flex shrink-0 items-center justify-center gap-2 rounded-none border-2 border-black " \
            "text-sm font-bold uppercase tracking-wide whitespace-nowrap cursor-pointer " \
            "shadow-[4px_4px_0_0_#000] transition-transform " \
            "hover:-translate-x-0.5 hover:-translate-y-0.5 hover:shadow-[6px_6px_0_0_#000] " \
            "active:translate-x-[3px] active:translate-y-[3px] active:shadow-[1px_1px_0_0_#000] " \
            "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
            "disabled:pointer-events-none disabled:opacity-50 " \
            "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"
        end

        def variants
          {
            default:     "bg-yellow-300 text-black",
            destructive: "bg-red-500 text-white",
            outline:     "bg-white text-black",
            secondary:   "bg-pink-300 text-black",
            ghost:       "bg-transparent border-transparent shadow-none hover:bg-yellow-100",
            link:        "bg-transparent border-transparent shadow-none underline normal-case"
          }
        end
      end

      class Card < Shadcnrb::Card::Style
        def root  = "flex flex-col gap-6 rounded-none border-2 border-black bg-white py-6 text-black shadow-[8px_8px_0_0_#000]"
        def title = "leading-none font-black uppercase tracking-wide"
      end

      class Badge < Shadcnrb::Badge::Style
        def base
          "inline-flex w-fit shrink-0 items-center justify-center gap-1 overflow-hidden rounded-none border-2 border-black " \
            "px-2 py-0.5 text-xs font-bold uppercase tracking-wide whitespace-nowrap shadow-[2px_2px_0_0_#000] " \
            "[&>svg]:pointer-events-none [&>svg]:size-3"
        end

        def variants
          {
            default:     "bg-yellow-300 text-black",
            secondary:   "bg-pink-300 text-black",
            destructive: "bg-red-500 text-white",
            outline:     "bg-white text-black",
            ghost:       "bg-transparent border-transparent shadow-none",
            link:        "bg-transparent border-transparent shadow-none underline"
          }
        end
      end

      class Input < Shadcnrb::Input::Style
        def base
          "h-10 w-full min-w-0 rounded-none border-2 border-black bg-white px-3 py-1 text-sm " \
            "shadow-[3px_3px_0_0_#000] outline-none transition-shadow " \
            "focus:-translate-x-0.5 focus:-translate-y-0.5 focus:shadow-[5px_5px_0_0_#000] " \
            "placeholder:text-gray-500 disabled:pointer-events-none disabled:opacity-50"
        end
      end

      class Textarea < Shadcnrb::Textarea::Style
        def base
          "flex field-sizing-content min-h-24 w-full rounded-none border-2 border-black bg-white px-3 py-2 text-sm " \
            "shadow-[3px_3px_0_0_#000] outline-none placeholder:text-gray-500 " \
            "disabled:cursor-not-allowed disabled:opacity-50"
        end
      end

      class Alert < Shadcnrb::Alert::Style
        def base
          "relative grid w-full grid-cols-[0_1fr] items-start gap-y-0.5 rounded-none border-2 border-black px-4 py-3 text-sm shadow-[4px_4px_0_0_#000] " \
            "has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr] has-[>svg]:gap-x-3 " \
            "[&>svg]:size-4 [&>svg]:translate-y-0.5 [&>svg]:text-current"
        end

        def variants
          {
            default:     "bg-yellow-300 text-black",
            destructive: "bg-red-500 text-white"
          }
        end

        def title = "col-start-2 line-clamp-1 min-h-4 font-black uppercase tracking-wide"
      end

      class Dialog < Shadcnrb::Dialog::Style
        def content
          "fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)] " \
            "translate-x-[-50%] translate-y-[-50%] gap-4 rounded-none border-2 border-black bg-white p-6 " \
            "shadow-[8px_8px_0_0_#000] outline-none " \
            "pointer-events-none opacity-0 scale-95 transition-all duration-200 " \
            "data-[state=open]:pointer-events-auto data-[state=open]:opacity-100 data-[state=open]:scale-100 " \
            "data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 " \
            "data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95 " \
            "sm:max-w-lg"
        end

        def title = "text-lg leading-none font-black uppercase tracking-wide"
      end

      class Tabs < Shadcnrb::Tabs::Style
        def list
          "inline-flex w-fit items-center justify-center rounded-none border-2 border-black bg-white p-1 h-10 " \
            "shadow-[3px_3px_0_0_#000]"
        end

        def trigger
          "relative inline-flex h-full flex-1 items-center justify-center gap-1.5 rounded-none border-2 border-transparent " \
            "px-3 py-1 text-sm font-bold uppercase tracking-wide whitespace-nowrap cursor-pointer " \
            "transition-colors hover:bg-yellow-100 " \
            "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
            "disabled:pointer-events-none disabled:opacity-50 " \
            "data-[state=active]:bg-yellow-300 data-[state=active]:border-black"
        end
      end

      class Sidebar < Shadcnrb::Sidebar::Style
        # Thick right border, white bg, no rounding.
        def root_inner
          "flex h-full w-full flex-col bg-white border-r-2 border-black " \
            "group-data-[variant=floating]:rounded-none group-data-[variant=floating]:border-2 group-data-[variant=floating]:border-black group-data-[variant=floating]:shadow-[4px_4px_0_0_#000]"
        end

        def root_none = "flex h-full w-[var(--sidebar-width)] flex-col bg-white border-r-2 border-black text-black"

        def group_label
          "flex h-8 shrink-0 items-center rounded-none px-2 text-xs font-black uppercase tracking-wider text-black outline-hidden " \
            "transition-[margin,opacity] duration-200 ease-linear [&>svg]:size-4 [&>svg]:shrink-0 " \
            "group-data-[collapsible=icon]:-mt-8 group-data-[collapsible=icon]:opacity-0"
        end

        def menu_button_base
          "peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-none border-2 border-transparent p-2 text-left text-sm font-bold uppercase tracking-wide " \
            "outline-hidden transition-[width,height,padding] " \
            "group-has-data-[sidebar=menu-action]/menu-item:pr-8 group-data-[collapsible=icon]:size-8! group-data-[collapsible=icon]:p-2! " \
            "hover:bg-yellow-100 " \
            "focus-visible:ring-2 focus-visible:ring-black " \
            "disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none aria-disabled:opacity-50 " \
            "[&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0"
        end

        def menu_button_variant_default = "hover:bg-yellow-100"
        def menu_button_variant_outline = "bg-white border-black hover:bg-yellow-100"
        def menu_button_inactive = "text-black"
        def menu_button_active   = "bg-yellow-300 border-black text-black shadow-[2px_2px_0_0_#000]"

        def separator = "mx-2 w-auto border-2 border-black"

        def menu_sub = "mx-3.5 flex min-w-0 translate-x-px flex-col gap-1 border-l-2 border-black px-2.5 py-0.5 group-data-[collapsible=icon]:hidden"

        def menu_sub_button_base
          "flex h-7 min-w-0 -translate-x-px items-center gap-2 overflow-hidden rounded-none border-2 border-transparent px-2 text-black font-semibold uppercase tracking-wide " \
            "outline-hidden hover:bg-yellow-100 focus-visible:ring-2 focus-visible:ring-black " \
            "disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none aria-disabled:opacity-50 " \
            "[&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0 " \
            "data-[active=true]:bg-yellow-300 data-[active=true]:border-black data-[active=true]:shadow-[2px_2px_0_0_#000] " \
            "group-data-[collapsible=icon]:hidden"
        end

        def trigger
          "inline-flex items-center justify-center rounded-none border-2 border-black h-8 w-8 text-sm cursor-pointer " \
            "bg-white shadow-[2px_2px_0_0_#000] hover:bg-yellow-100"
        end

        def inset_header = "flex h-14 shrink-0 items-center gap-2 border-b-2 border-black px-6 bg-white"
      end

      class NavigationMenu < Shadcnrb::NavigationMenu::Style
        def link
          "inline-flex h-9 w-max items-center justify-center rounded-none border-2 border-black bg-white px-4 py-2 " \
            "text-sm font-bold uppercase tracking-wide shadow-[2px_2px_0_0_#000] " \
            "transition-transform hover:-translate-x-0.5 hover:-translate-y-0.5 hover:shadow-[4px_4px_0_0_#000] " \
            "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
            "disabled:pointer-events-none disabled:opacity-50 " \
            "data-[active=true]:bg-yellow-300"
        end
      end

      class Avatar < Shadcnrb::Avatar::Style
        def root     = "relative flex size-10 shrink-0 overflow-hidden rounded-none border-2 border-black bg-yellow-300 shadow-[3px_3px_0_0_#000] select-none data-[size=lg]:size-12 data-[size=sm]:size-8"
        def image    = "aspect-square size-full"
        def fallback = "flex size-full items-center justify-center text-sm font-black uppercase text-black"
      end

      class Breadcrumb < Shadcnrb::Breadcrumb::Style
        def list      = "flex flex-wrap items-center gap-1.5 text-sm break-words text-black sm:gap-2.5"
        def link      = "font-bold uppercase tracking-wide underline underline-offset-4 hover:text-black hover:bg-yellow-100"
        def page      = "font-black uppercase tracking-wide text-black"
        def separator = "[&>svg]:size-3.5 text-black"
      end

      class ButtonGroup < Shadcnrb::ButtonGroup::Style
        def variants
          {
            horizontal: "[&>*:not(:first-child)]:border-l-0 [&>*:not(:first-child)]:shadow-[0_4px_0_0_#000] [&>*:not(:last-child)]:border-r-2",
            vertical:   "flex-col [&>*:not(:first-child)]:border-t-0 [&>*:not(:last-child)]:border-b-2"
          }
        end

        def separator = "relative m-0! self-stretch bg-black w-[2px] data-[orientation=vertical]:h-auto"

        def text
          "flex items-center gap-2 rounded-none border-2 border-black bg-yellow-300 px-4 text-sm font-bold uppercase tracking-wide shadow-[3px_3px_0_0_#000] " \
            "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4"
        end
      end

      class Checkbox < Shadcnrb::Checkbox::Style
        def base
          "peer size-5 shrink-0 cursor-pointer appearance-none rounded-none border-2 border-black bg-white shadow-[2px_2px_0_0_#000] outline-none " \
            "checked:bg-yellow-300 checked:border-black " \
            "focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
            "disabled:cursor-not-allowed disabled:opacity-50 " \
            "checked:bg-[url('data:image/svg+xml;utf8,%3Csvg%20viewBox%3D%220%200%2016%2016%22%20fill%3D%22black%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Cpath%20d%3D%22M12.207%204.793a1%201%200%200%201%200%201.414l-5%205a1%201%200%200%201-1.414%200l-2-2a1%201%200%200%201%201.414-1.414L6.5%209.086l4.293-4.293a1%201%200%200%201%201.414%200z%22%2F%3E%3C%2Fsvg%3E')] checked:bg-center checked:bg-no-repeat"
        end
      end

      class Codeblock < Shadcnrb::Codeblock::Style
        def base = "shadcnrb-code relative overflow-x-auto rounded-none border-2 border-black bg-white text-sm shadow-[4px_4px_0_0_#000]"
        def pre  = "p-4 font-mono leading-relaxed"
      end

      class Drawer < Shadcnrb::Drawer::Style
        def content_base = "fixed z-50 flex h-auto flex-col bg-white border-2 border-black shadow-[8px_8px_0_0_#000] transition-transform duration-300 ease-in-out"

        def sides
          {
            right:  "inset-y-0 right-0 h-full w-3/4 max-w-sm border-l-2 translate-x-full data-[state=open]:translate-x-0",
            left:   "inset-y-0 left-0 h-full w-3/4 max-w-sm border-r-2 -translate-x-full data-[state=open]:translate-x-0",
            top:    "inset-x-0 top-0 h-auto max-h-[80vh] mb-24 border-b-2 -translate-y-full data-[state=open]:translate-y-0",
            bottom: "inset-x-0 bottom-0 h-auto max-h-[80vh] mt-24 border-t-2 translate-y-full data-[state=open]:translate-y-0"
          }
        end

        def title       = "font-black uppercase tracking-wide text-black"
        def description = "text-sm text-black"
      end

      class DropdownMenu < Shadcnrb::DropdownMenu::Style
        # Placement is inline-styled by the anchored controller; only
        # cosmetics belong here (same for tooltip/hover_card below).
        def content
          "fixed z-50 min-w-[8rem] rounded-none border-2 border-black bg-white p-1 " \
            "text-black shadow-[4px_4px_0_0_#000] " \
            "hidden data-[state=open]:block"
        end

        def label     = "px-2 py-1.5 text-sm font-black uppercase tracking-wide"
        def separator = "-mx-1 my-1 h-[2px] bg-black"

        def item
          "relative flex w-full cursor-pointer items-center gap-2 rounded-none px-2 py-1.5 text-sm font-bold uppercase tracking-wide " \
            "outline-none select-none hover:bg-yellow-300 " \
            "disabled:pointer-events-none disabled:opacity-50"
        end
      end

      class Tooltip < Shadcnrb::Tooltip::Style
        def content
          "fixed z-50 w-fit max-w-xs overflow-visible rounded-none border-2 border-black bg-yellow-300 " \
            "px-3 py-1.5 text-xs font-bold text-black shadow-[3px_3px_0_0_#000] " \
            "hidden data-[state=open]:block"
        end

        def arrow = "absolute size-2.5 rotate-45 bg-black"
      end

      class HoverCard < Shadcnrb::HoverCard::Style
        def content
          "fixed z-50 w-64 overflow-visible rounded-none border-2 border-black bg-white p-4 " \
            "text-black shadow-[6px_6px_0_0_#000] " \
            "hidden data-[state=open]:block"
        end
      end

      class Skeleton < Shadcnrb::Skeleton::Style
        def base = "bg-yellow-100 border-2 border-black rounded-none animate-pulse"
      end

      class Empty < Shadcnrb::Empty::Style
        def root = "flex min-w-0 flex-1 flex-col items-center justify-center gap-6 rounded-none border-4 border-dashed border-black bg-white p-6 text-center text-balance md:p-12"

        def media_variants
          {
            default: "bg-transparent",
            icon:    "flex size-12 shrink-0 items-center justify-center rounded-none border-2 border-black bg-yellow-300 text-black shadow-[3px_3px_0_0_#000] [&_svg:not([class*='size-'])]:size-6"
          }
        end

        def title       = "text-lg font-black uppercase tracking-wide text-black"
        def description = "text-sm/relaxed text-black"
      end

      class FormField < Shadcnrb::FormField::Style
        def label       = "text-sm font-black uppercase tracking-wide leading-none text-black"
        def description = "text-sm text-black"
        def error       = "text-sm font-bold text-red-600"
      end

      class Label < Shadcnrb::Label::Style
        def base
          "flex items-center gap-2 text-sm leading-none font-black uppercase tracking-wide select-none text-black " \
            "group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50 " \
            "peer-disabled:cursor-not-allowed peer-disabled:opacity-50"
        end
      end

      class Link < Shadcnrb::Link::Style
        def base
          "cursor-pointer font-bold transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black " \
            "underline underline-offset-4 disabled:pointer-events-none disabled:opacity-50"
        end

        def variants
          {
            link:       "text-black hover:bg-yellow-100",
            underline:  "text-black hover:bg-yellow-100",
            muted:      "text-black/70 hover:text-black",
            foreground: "text-black hover:bg-yellow-100"
          }
        end
      end

      class Progress < Shadcnrb::Progress::Style
        def root      = "relative h-3 w-full overflow-hidden rounded-none border-2 border-black bg-white"
        def indicator = "h-full w-full flex-1 bg-yellow-300 transition-all"
      end

      class RadioGroup < Shadcnrb::RadioGroup::Style
        def item
          "peer size-5 shrink-0 cursor-pointer appearance-none rounded-full border-2 border-black bg-white shadow-[2px_2px_0_0_#000] outline-none " \
            "checked:border-black " \
            "focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
            "disabled:cursor-not-allowed disabled:opacity-50 " \
            "checked:bg-[radial-gradient(circle_at_center,#000_0_45%,#facc15_50%_100%)]"
        end
      end

      class Select < Shadcnrb::Select::Style
        def base
          "h-10 w-full min-w-0 appearance-none rounded-none border-2 border-black bg-white px-3 py-2 pr-9 text-sm font-bold " \
            "shadow-[3px_3px_0_0_#000] outline-none cursor-pointer " \
            "disabled:pointer-events-none disabled:cursor-not-allowed " \
            "focus:-translate-x-0.5 focus:-translate-y-0.5 focus:shadow-[5px_5px_0_0_#000] " \
            "data-[size=sm]:h-8 data-[size=sm]:py-1"
        end

        def chevron = "pointer-events-none absolute top-1/2 right-3 size-4 -translate-y-1/2 text-black select-none"
      end

      class Separator < Shadcnrb::Separator::Style
        def base = "shrink-0 bg-black data-[orientation=horizontal]:h-[2px] data-[orientation=horizontal]:w-full data-[orientation=vertical]:h-full data-[orientation=vertical]:w-[2px]"
      end

      class Switch < Shadcnrb::Switch::Style
        def root
          "peer group/switch inline-flex shrink-0 items-center rounded-none border-2 border-black bg-white shadow-[2px_2px_0_0_#000] outline-none cursor-pointer " \
            "focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
            "disabled:cursor-not-allowed disabled:opacity-50 " \
            "data-[size=default]:h-6 data-[size=default]:w-11 " \
            "data-[size=sm]:h-5 data-[size=sm]:w-8 " \
            "data-[state=checked]:bg-yellow-300"
        end

        def thumb
          "pointer-events-none block rounded-none border-2 border-black bg-white ring-0 transition-transform " \
            "group-data-[size=default]/switch:size-5 group-data-[size=sm]/switch:size-4 " \
            "data-[state=checked]:translate-x-[calc(100%-2px)] data-[state=unchecked]:translate-x-0"
        end
      end

      class Table < Shadcnrb::Table::Style
        def container = "relative w-full overflow-x-auto rounded-none border-2 border-black shadow-[4px_4px_0_0_#000]"
        def base      = "w-full caption-bottom text-sm"
        def header    = "[&_tr]:border-b-2 [&_tr]:border-black bg-yellow-300"
        def body      = "[&_tr:last-child]:border-0"
        def footer    = "border-t-2 border-black bg-yellow-100 font-bold [&>tr]:last:border-b-0"
        def row       = "border-b-2 border-black transition-colors hover:bg-yellow-100 data-[state=selected]:bg-yellow-300"
        def head      = "h-10 px-3 text-left align-middle font-black uppercase tracking-wide whitespace-nowrap text-black [&:has([role=checkbox])]:pr-0"
        def cell      = "p-3 align-middle whitespace-nowrap text-black [&:has([role=checkbox])]:pr-0"
        def caption   = "mt-4 text-sm font-bold text-black"
      end

      class Toast < Shadcnrb::Toast::Style
        def base
          "pointer-events-auto relative flex w-full items-center justify-between space-x-2 " \
            "overflow-hidden rounded-none border-2 border-black p-4 shadow-[4px_4px_0_0_#000] transition-all"
        end

        def variants
          {
            default:     "bg-yellow-300 text-black",
            destructive: "bg-red-500 text-white"
          }
        end
      end

      class ThemeSwitcher < Shadcnrb::ThemeSwitcher::Style
        def swatch_button
          "group flex flex-col items-center gap-1 rounded-none border-2 border-transparent p-2 text-xs font-bold uppercase cursor-pointer " \
            "hover:bg-yellow-100 " \
            "data-[selected=true]:border-black data-[selected=true]:bg-yellow-300 data-[selected=true]:shadow-[2px_2px_0_0_#000]"
        end

        def mode_button
          "flex items-center justify-center gap-1.5 rounded-none border-2 border-black bg-white px-2 py-1.5 text-xs font-bold uppercase tracking-wide cursor-pointer " \
            "shadow-[2px_2px_0_0_#000] hover:bg-yellow-100 " \
            "data-[selected=true]:bg-yellow-300"
        end
      end

      class Typography < Shadcnrb::Typography::Style
        def h1    = "text-4xl font-black uppercase tracking-tight"
        def h2    = "text-2xl font-black uppercase tracking-tight"
        def h3    = "text-lg font-black uppercase tracking-tight"
        def h4    = "text-base font-bold uppercase tracking-wide"
        def p     = "text-sm leading-relaxed text-black"
        def lead  = "text-lg font-bold text-black"
        def muted = "text-sm text-black/70"
        def code  = "text-xs bg-yellow-200 border-2 border-black px-1.5 py-0.5 font-mono font-bold"
      end

    end
  end
end
