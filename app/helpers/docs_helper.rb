require "method_source"

module DocsHelper
  # Original signature with explicit code string + block.
  # Use when you need a custom display string (e.g. multi-line ruby formatted nicely).
  def docs_example(code, &block)
    render "docs/example", code: code, syntax: syntax_for(code), block: block, frame: true
  end

  # Single-source-of-truth example — captures the block's source automatically and
  # strips ERB tags for display. Use this when the rendered Ruby IS what you want shown.
  #
  #   <%= live_example do %>
  #     <%= sui.button "Save" %>
  #   <% end %>
  #
  # Renders both the live `sui.button` and shows the source `sui.button "Save"` in the
  # code block — no duplication.
  # `frame: false` drops the padded card around the preview — for tables and
  # other full-width pieces that draw their own edges.
  def live_example(frame: true, &block)
    code = capture_erb_block(block) || "# (source not available)"
    render "docs/example", code: code, syntax: syntax_for(code), block: block, frame: frame
  end

  # Block preview + source below — used on the /blocks pages. The block is a
  # partial under `blocks/demos/` rendered as its own page in an iframe, so
  # its sidebar, overlays and fixed elements are bounded by the frame the way
  # any page's are; the source shown is that partial, verbatim.
  def block_example(id, height:)
    code = File.read(Rails.root.join("app/views/blocks/demos/_#{id}.html.erb"))
    render "blocks/example", id: id, height: height, code: code, syntax: syntax_for(code)
  end

  # A project file's source under its path, for the pieces of an example
  # that live outside the page; `only:` narrows it to a matching slice.
  def source_block(path, only: nil)
    code = File.read(Rails.root.join(path))
    code = code[only].strip_heredoc if only
    syntax = { ".js" => :javascript, ".erb" => :erb, ".rb" => :ruby, ".css" => :css }.fetch(File.extname(path)) { syntax_for(code) }
    tag.div(class: "space-y-1") do
      tag.p(path, class: "font-mono text-xs text-muted-foreground") + sui.codeblock(code, syntax:)
    end
  end

  # Rouge's ERB lexer treats non-ERB content as HTML text, so pure-Ruby
  # snippets come out unhighlighted under `:erb`. Pick `:ruby` when there's
  # no `<%` tag.
  def syntax_for(code)
    code.to_s.include?("<%") ? :erb : :ruby
  end

  def docs_components
    DocsController::COMPONENTS
  end

  # Per-component install snippet — drop at the top of each docs page right
  # under the lead. Mirrors shadcn/ui's "Installation" section.
  def install_block(component)
    sui.codeblock <<~SH.strip, syntax: :shell
      bin/rails g shadcnrb:component #{component}
    SH
  end

  # API reference table for component docs. Rows are raw arrays; each cell is
  # passed through as HTML (so inline `<code>` tags work). Headers default to
  # the usual shape but any list works.
  #
  #   <%= api_table rows: [
  #     ["sui.card", "**opts, &block", "—", "Root card; yields a <code>c</code> proxy"],
  #     ["c.header", "**opts, &block", "—", "Header grid"],
  #   ] %>
# Pages opt in with `content_for :full_width`; the header toggle sets the cookie.
def docs_full_width?
  content_for?(:full_width) || cookies[:docs_width] == "full"
end

def api_table(rows:, headers: %w[Method Args Default Description])
    content_tag(:div) do
      sui.table class: "rounded-lg border" do |t|
        safe_join([
          t.header { t.row { safe_join(headers.map { |h| t.head(h) }) } },
          t.body   { safe_join(rows.map { |r| t.row { safe_join(r.map { |c| t.cell(c.to_s.html_safe, class: "whitespace-normal") }) } }) }
        ])
      end
    end
  end


  def docs_active?(path)
    current_page?(path)
  end

  # ERB snippets as literal strings (ERB-in-ERB can't be heredoc'd in a view
  # — the scanner closes on the first `%>` inside the heredoc).
  THEME_SWITCHER_SNIPPET = <<~ERB
    <html class="<%= sui.theme_class %>">   <%# renders the saved choice, no flash on reload %>
    <%= sui.theme_switcher %>               <%# anywhere in your UI %>
  ERB

  THEME_SWITCHER_REGISTER_SNIPPET = <<~ERB
    <%= sui.theme_switcher themes: %w[default blue green brand] %>
  ERB

  OVERRIDING_VARIANT_USE_SNIPPET = <<~ERB
    <%= sui.button "Brand action", variant: :outline_primary %>
  ERB

  private

  # ERB blocks compile to anonymous methods, so method_source can't reach them via
  # block.source. But block.source_location DOES point at the .erb file. Read the
  # file from there, find the matching `<% end %>`, extract the inner content,
  # dedent.
  #
  # Quirk: source_location can point at either the line with `do %>` OR the
  # first body line that follows it, depending on how ERB compiled the block.
  # Sniff the first line — if it opens a `do` block, start body AFTER it; if
  # not, we're already inside the block.
  #
  # Depth tracking scans ERB tags as units (possibly multi-line) — a naive
  # line-by-line scan misses `<% [...].each do |...| %>` when the array
  # literal spans multiple lines, and the depth drifts below zero as the
  # matching `<% end %>` is found without its opener.
  ERB_TAG_RE    = /<%=?(?:[^%]|%(?!>))*?%>/m
  ERB_END_RE    = /\A<%\s*end\s*%>\z/
  ERB_DO_RE     = /\bdo\b\s*(?:\|[^|]*\|)?\s*%>\z/
  OPENER_RE     = /\b(?:live|block|docs)_example\b.*\bdo\s*%>/

  def capture_erb_block(block)
    file, line = block.source_location
    return nil unless file && line && File.exist?(file)
    return nil unless file.end_with?(".erb")

    lines = File.readlines(file)
    start_idx = line - 1
    return nil if start_idx >= lines.length

    body_start = lines[start_idx].match?(OPENER_RE) ? start_idx + 1 : start_idx
    body_text = lines[body_start..].join

    depth = 1
    end_pos = nil
    body_text.scan(ERB_TAG_RE) do |tag|
      match = Regexp.last_match
      if tag =~ ERB_END_RE
        depth -= 1
        if depth.zero?
          end_pos = match.begin(0)
          break
        end
      elsif tag =~ ERB_DO_RE
        depth += 1
      end
    end
    return nil unless end_pos

    # Trim back to the newline before the terminating `<% end %>` so that
    # line is excluded from the displayed source.
    last_nl = body_text[0...end_pos].rindex("\n")
    inner = last_nl ? body_text[0..last_nl] : body_text[0...end_pos]
    dedent(inner)
  end

  def dedent(text)
    lines = text.lines
    indent = lines.reject { |l| l.strip.empty? }
                  .map { |l| l[/\A\s*/].length }
                  .min || 0
    lines.map { |l| l.empty? ? l : l[indent..] || l }.join.strip
  end
end
