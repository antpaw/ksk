module Ksk
  module ApplicationHelper

    def recursive_navi(navis, current_level = 0, max_level = 99)
      a = ' <ul>'
      navis.each do |navi|
        active = navi.slug == @slugs[current_level] ? ' class="active"' : nil
        next unless nt = navi.navigation_type
        link = if nt.name == 'news'
          link_to navi.title, posts_path
        else
          link_to navi.title, navi.link
        end
        a += " <li#{active}>#{link}"
        if active && current_level <= max_level && navi.children.not_hidden.any?
          a += recursive_navi(navi.children.not_hidden, current_level+1, max_level)
        end
        a += '</li> '
      end
      a += '</ul> '
    end

    def md(text)
      return '' if text.blank?
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(), fenced_code_blocks: true, autolink: true)
      markdown.render(text).html_safe
    end

    def mdap(text, images, data_files)
      return '' if text.blank?
      t = place_images(text, images)
      t = place_data_files(t, data_files)
      md(t)
    end

    def place_content(text, files, type, &html)
      t = text
      (text || '').scan(Apdown.parse_regex(type)).each do |match|
        if asset = files[match[1].to_i-1]
          t = t.gsub(match[0], html.call(asset, match[2]))
        end
      end
      t.html_safe
    end

    def place_images(text, images)
      place_content(text, images, 'img') do |asset, option|
        c = option || 'thumb'
        image_tag asset.file.url(c), class: ['uploaded_image', c]
      end
    end

    def place_data_files(text, data_files)
      place_content(text, data_files, 'file') do |asset, option|
        link_to asset.file.url, title: asset.file.original_filename, class: asset.has_preview? ? :uploaded_file_preview : :uploaded_file do
          if asset.has_preview?
            if asset.has_preview_image?
              t_capition = !asset.preview.name.blank? ? asset.preview.name : t('ksk.asset.file_preview.button.download')
              image_tag( asset.preview_file.url(:banner) )+
              "<span>#{t_capition}</span>".html_safe
            else
              asset.preview.name
            end
          else
            asset.file_file_name
          end
        end
      end
    end

  end
end