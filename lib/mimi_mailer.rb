require 'httparty'
require "mimi_mailer/version"
require 'mimi_mailer/base'
require 'mimi_mailer/configuration'

module MimiMailer
  class InvalidConfigurationError < StandardError;end

  extend self

  def configure
    raise ArgumentError.new("A block must be supplied") unless block_given?
    yield config
  end

  def config
    @config ||= MimiMailer::Configuration.new
  end

  def enable_deliveries!
    config.deliveries_enabled = true
  end

  def disable_deliveries!
    config.deliveries_enabled = false
  end

  def deliveries_enabled?
    config.deliveries_enabled
  end
end
