class RelationshipsController < ApplicationController
  def index
    @contacts       = current_user.non_self_voters.order(:sos_id).load
    @contacted_size = (@contacts).count { |v| !v.not_yet_called? }
  end
end
