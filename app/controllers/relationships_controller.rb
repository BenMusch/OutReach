class RelationshipsController < ApplicationController
  def index
    @contacts           = current_user.non_self_voters.order('support_score DESC, sos_id ASC').load
    @secondary_contacts = current_user.secondary_network.order('support_score DESC, sos_id ASC').load

    @contacted_size = (@contacts + @secondary_contacts).count { |v| !v.not_yet_called? }
    @excluded_size  = (@contacts + @secondary_contacts).count { |v| v.support_score == 0 }

    @contacts           = @contacts.reject { |v| v.support_score == 0 }
    @secondary_contacts = @secondary_contacts.reject { |v| v.support_score == 0 }
  end
end
