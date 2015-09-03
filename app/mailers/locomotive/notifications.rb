module Locomotive
  class Notifications < ActionMailer::Base

    default from: Locomotive.config.mailer_sender

    def new_content_entry(account, entry)
      @account, @entry, @type = account, entry, entry.content_type

      if Locomotive.config.multi_sites_or_manage_domains?
        @domain = entry.site.domains.first
      else
        @domain = ActionMailer::Base.default_url_options[:host] || 'localhost'
      end

      subject = new_content_entry_subject(entry, domain: @domain, type: @type.name, locale: account.locale)

      mail subject: subject, to: account.email
    end

    protected

    def new_content_entry_subject(entry, options)
      if entry.content_type.public_submission_title_template.blank?
        t('locomotive.notifications.new_content_entry.subject', options)
      else
        entry.content_type.public_submission_title(entry, options)
      end
    end

  end

end
