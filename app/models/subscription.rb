# frozen_string_literal: true

class Subscription < ApplicationRecord
	enum :state, { unpaid: 0, paid: 1, canceled: 2 }
end
