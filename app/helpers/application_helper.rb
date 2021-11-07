module ApplicationHelper

  # ページごとの完全なタイトルを返す。
  def full_title(page_title = '')
    base_title = "5Keeps"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def default_meta_tags
    {
      description: t('helpers.description'),
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      og: {
        site_name: '5Keeps',
        title: t('helpers.ogp.title'),
        description: t('helpers.ogp.description'), 
        type: 'website',
        url: request.original_url,
        image: image_url(t('helpers.ogp.image')),
      },
      twitter: {
        card: 'summary_large_image',
      }
    }
  end
end
