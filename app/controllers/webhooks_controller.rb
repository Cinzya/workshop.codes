class WebhooksController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def bugsnag_error_reporting
    return unless ENV["DISCORD_BUGSNAG_WEBHOOK_URL"].present?

    type = params["trigger"]["type"]
    message = params["trigger"]["message"]
    rate = params["trigger"]["rate"]
    error_message = params["error"]["message"]
    datetime = params["error"]["receivedAt"]

    embed = Discord::Embed.new do
      color "#ff0000"
      title "😯 Something is going wrong with Workshop.codes"
      description "#{ type }: **#{ message }** \n\n #{ error_message }"
      add_field name: "Rate", value: rate if rate.present?
      add_field name: "Datetime", value: datetime
    end

    Discord::Notifier.message(embed, url: ENV["DISCORD_BUGSNAG_WEBHOOK_URL"], username: "Workshop.codes Errors")
  end

  def ko_fi
    data = JSON.parse params[:data]

    WebhookValue.create(name: "ko_fi", value: data["amount"])
  end

  def get_ko_fi_value
    @values = WebhookValue.where(name: "ko_fi").where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)

    if @values.any?
      @value = @values.pluck(:value).sum(&:to_f)
    else
      @value = 0
    end

    render json: @value, layout: false
  end
end
