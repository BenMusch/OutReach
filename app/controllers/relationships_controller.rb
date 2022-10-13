class RelationshipsController < ApplicationController
  def index
    @contacts       = current_user.non_self_voters.order(:sos_id).load
    @secondary_contacts = current_user.secondary_network.order(:sos_id).load
    @contacted_size = (@contacts + @secondary_contacts).count { |v| !v.not_yet_called? }
  end
end
