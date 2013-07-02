module Spree
  module BaseHelper

    # Defined because Rails' current_page? helper is not working when Spree is mounted at root.
    def current_spree_page?(url)
      path = request.fullpath.gsub(/^\/\//, '/')
      if url.is_a?(String)
        return path == url
      elsif url.is_a?(Hash)
        return path == spree.url_for(url)
      end
      return false
    end

    def dropdown(name, link, items={}, taxon_root=nil)
      unless taxon_root.nil?
        taxon_links = get_taxonomies.where(:name => taxon_root).map {|taxonomy| taxonomy.root.children.map {|taxon| {taxon.name.downcase => seo_url(taxon)} }}
        items.merge(taxon_links)
      end
      menu_item = items.map { |x, y| content_tag(:li, link_to(Spree.t(x), y)) }
      content_tag :li, class: "dropdown" do
        link_to(Spree.t(name), link, class: "dropdown-toggle", :'data-hover' => "dropdown", :'data-delay' => "0") +
        unless items.empty? 
          content_tag(:ul, menu_item.join.html_safe, class: "dropdown-menu")
        end
      end
    end

    def link_to_cart(text = nil)
      text = text ? h(text) : Spree.t('cart')
      css_class = nil

      if current_order.nil? or current_order.line_items.empty?
        text = "#{text}: (#{Spree.t('empty')})"
        css_class = 'empty'
      else
        text = "#{text}: (#{current_order.item_count})  <span class='amount'>#{current_order.display_total.to_html}</span>".html_safe
        css_class = 'full'
      end

      link_to text, spree.cart_path, :class => "cart-info #{css_class}"
    end

    # human readable list of variant options
    def variant_options(v, options={})
      v.options_text
    end

    def meta_data_tags
      object = instance_variable_get('@'+controller_name.singularize)
      meta = {}

      if object.kind_of? ActiveRecord::Base
        meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
        meta[:description] = object.meta_description if object[:meta_description].present?
      end

      if meta[:description].blank? && object.kind_of?(Spree::Product)
        meta[:description] = strip_tags(truncate(object.description, length: 160, separator: ' '))
      end

      meta.reverse_merge!({
        keywords: Spree::Config[:default_meta_keywords],
        description: Spree::Config[:default_meta_description]
      })

      meta.map do |name, content|
        tag('meta', name: name, content: content)
      end.join("\n")
    end

    def body_class
      @body_class ||= content_for?(:sidebar) ? 'two-col' : 'one-col'
      @body_class
    end

    def logo(image_path=Spree::Config[:logo])
      link_to image_tag(image_path), spree.root_path
    end

    def flash_messages(opts = {})
      opts[:ignore_types] = [:commerce_tracking].concat(Array(opts[:ignore_types]) || [])

      flash.each do |msg_type, text|
        unless opts[:ignore_types].include?(msg_type)
          concat(content_tag :div, text, class: "flash #{msg_type}")
        end
      end
      nil
    end

    def breadcrumbs(taxon, separator="&nbsp;&raquo;&nbsp;")
      return "" if current_page?("/") || taxon.nil?
      separator = raw(separator)
      crumbs = [content_tag(:li, link_to(Spree.t(:home) , root_path) + separator)]
      if taxon
        crumbs << content_tag(:li, link_to(Spree.t(:products) , products_path) + separator)
        crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + separator) } unless taxon.ancestors.empty?
        crumbs << content_tag(:li, content_tag(:span, link_to(taxon.name , seo_url(taxon))))
      else
        crumbs << content_tag(:li, content_tag(:span, Spree.t(:products)))
      end
      crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), :class => 'inline')
      content_for :crumblist do
        content_tag(:nav, crumb_list)
      end
      render(partial: 'spree/products/inventory_header')
    end

    def taxons_tree(root_taxon, current_taxon, max_level = 1)
      return '' if max_level < 1 || root_taxon.children.empty?
      content_tag :ul, class: 'taxons-list' do
        root_taxon.children.map do |taxon|
          css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'current' : nil
          content_tag :li, class: css_class do
            if taxon == current_taxon
              link_to(current_taxon.name, seo_url(current_taxon)) +
              taxons_tree(current_taxon, current_taxon)
            elsif !current_taxon.nil? && taxon == current_taxon.parent
              current_taxon = current_taxon.parent
              link_to(current_taxon.name, seo_url(current_taxon)) +
              taxons_tree(current_taxon, current_taxon)
            else
              link_to(taxon.name, seo_url(taxon)) +
              taxons_tree(taxon, current_taxon, max_level - 1)
            end
          end
        end.join("\n").html_safe
      end
    end

    def available_countries
      checkout_zone = Zone.find_by_name(Spree::Config[:checkout_zone])

      if checkout_zone && checkout_zone.kind == 'country'
        countries = checkout_zone.country_list
      else
        countries = Country.all
      end

      countries.collect do |country|
        country.name = Spree.t(country.iso, scope: 'country_names', default: country.name)
        country
      end.sort { |a, b| a.name <=> b.name }
    end

    def seo_url(taxon)
      return spree.nested_taxons_path(taxon.permalink)
    end

    def gem_available?(name)
       Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
       false
    rescue
       Gem.available?(name)
    end

    def money(amount)
      ActiveSupport::Deprecation.warn("[SPREE] Spree::BaseHelper#money will be deprecated.  It relies upon a single master currency.  You can instead create a Spree::Money.new(amount, { :currency => your_currency}) or see if the object you're working with returns a Spree::Money object to use.")
      Spree::Money.new(amount)
    end

    def display_price(product_or_variant)
      product_or_variant.price_in(current_currency).display_price.to_html
    end

    def pretty_time(time)
      [I18n.l(time.to_date, format: :long),
        time.strftime("%l:%M %p")].join(" ")
    end

    def method_missing(method_name, *args, &block)
      if image_style = image_style_from_method_name(method_name)
        define_image_method(image_style)
        self.send(method_name, *args)
      else
        super
      end
    end

    def link_to_tracking(shipment, options = {})
      return unless shipment.tracking

      if shipment.tracking_url
        link_to(shipment.tracking, shipment.tracking_url, options)
      else
        content_tag(:span, shipment.tracking)
      end
    end

    def t(*args)
      puts "WARNING: Spree's translations are now scoped to a 'spree' namespace. Please use the Spree.t helper."
      puts "Called from: #{caller[0]}"
      I18n.t(*args)
    end


    private

    # Returns style of image or nil
    def image_style_from_method_name(method_name)
      if style = method_name.to_s.sub(/_image$/, '')
        possible_styles = Spree::Image.attachment_definitions[:attachment][:styles]
        style if style.in? possible_styles.with_indifferent_access
      end
    end

    def define_image_method(style)
      self.class.send :define_method, "#{style}_image" do |product, *options|
        options = options.first || {}
        if product.images.empty?
          image_tag "noimage/#{style}.png", options
        else
          image = product.images.first
          options.reverse_merge! alt: image.alt.blank? ? product.name : image.alt
          image_tag image.attachment.url(style), options
        end
      end
    end

  end
end