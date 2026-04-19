# Data for the data grid demo's orders, in pages the loader row fetches.
module TableDemoHelper
  PAGES = 3
  PER_PAGE = 20

  BADGE_VARIANT = { "Paid" => :default, "Pending" => :secondary, "Refunded" => :outline, "Failed" => :destructive }.freeze

  ORDER_SEEDS = [
    { customer: "Ada Lovelace",      notes: "Gift wrap requested, leave parcel with the concierge if nobody answers.", ship_to: "12 Analytical Row, Marylebone, London W1U 4AA, United Kingdom",              status: "Paid",     items: 3,  total: "$1,240.00" },
    { customer: "Grace Hopper",      notes: "Awaiting bank confirmation.",                                             ship_to: "1 Compiler Court, Arlington, VA 22201",                                    status: "Pending",  items: 1,  total: "$89.00" },
    { customer: "Hedy Lamarr",       notes: "Customer returned two items; refund issued to the original card.",         ship_to: "Frequency Hopping Studios, 88 Spread Spectrum Way, Vienna 1010, Austria", status: "Refunded", items: 7,  total: "$2,015.50" },
    { customer: "Katherine Johnson", notes: "Card declined twice.",                                                    ship_to: "Langley Research Center, Hampton, VA 23681",                               status: "Failed",   items: 2,  total: "$310.00" },
    { customer: "Margaret Hamilton", notes: "Split shipment: books ship now, the desk lamp follows next week.",         ship_to: "Draper Lab, 555 Technology Square, Cambridge, MA 02139",                   status: "Paid",     items: 12, total: "$4,780.25" }
  ].freeze

  def demo_orders(page)
    PER_PAGE.times.map do |n|
      i = (page - 1) * PER_PAGE + n
      ORDER_SEEDS[i % ORDER_SEEDS.size].merge(order: "ORD-#{10421 + i}", placed: (Date.new(2026, 9, 12) + i).iso8601)
    end
  end

  def demo_badge_variant(status) = BADGE_VARIANT[status]
end
