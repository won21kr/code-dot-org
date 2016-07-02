class PeerReviewsController < ApplicationController
  load_and_authorize_resource

  def index
    @available = @peer_reviews.where(reviewer: nil)
    @submitted = @peer_reviews.where(reviewer: current_user)
  end

  def show
    @level = @peer_review.level
    @last_attempt = @peer_review.level_source.data
    @script_level = ScriptLevel.where(script: @peer_review.script).detect(level: @peer_review.level).first
    @script = @peer_review.script
    view_options full_width: true, readonly_workspace: true
  end

  def update
    if @peer_review.update(peer_review_params.merge(reviewer: current_user))
      flash[:notice] = 'Your peer review was submitted'
      redirect_to script_path(@peer_review.script)
    else
      render action: :show
    end
  end

  private

  def peer_review_params
    params.require(:peer_review).permit(:data, :status)
  end
end
