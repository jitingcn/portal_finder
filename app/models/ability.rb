# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if @user.blank?
      roles_for_anonymous
    elsif @user.admin?
      can :manage, :all
    elsif @user.member?
      roles_for_members
    # elsif @user.vip?
    #   roles_for_members
    #   roles_for_vip
    # elsif @user.maintainer?
    #   roles_for_members
    #   roles_for_maintainer
    else
      roles_for_anonymous
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  protected

    def roles_for_anonymous
      cannot :read, :all
      cannot :manage, :all
      # basic_read_only
    end

    def roles_for_members
      basic_read_only
    end

    def basic_read_only
      can :read, Portal
      can :manage, IfsSearch
    end
end
