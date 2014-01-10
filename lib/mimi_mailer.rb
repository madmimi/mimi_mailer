require 'httparty'
require "mimi_mailer/version"
require 'mimi_mailer/base'
require 'mimi_mailer/configuration'

module MimiMailer
  extend self

  def configure
    raise ArgumentError.new("A block must be supplied") unless block_given?
    yield config
  end

  def config
    @config ||= MimiMailer::Configuration.new
  end
end
