require 'active_form'

class MailAddressForm < ActiveForm
  attr_accessor :mail_address

  validates_presence_of :mail_address
  validates_legal_mail_address_of :mail_address, :if => Proc.new{|form| !form.mail_address.blank?}

  _("mail address form")
  _("MailAddressForm|mail_address")
end