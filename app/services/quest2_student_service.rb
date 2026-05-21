class Quest2StudentService
  class << self
    def all_agents
      Agent.order(:codename).pluck(:codename).join("\n")
    end

    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    def agents_with_missions
      Agent.order(:codename).map do |agent|
        missions = agent.missions.order(:title).pluck(:title)
        "#{agent.codename}: #{missions.join(', ')}"
      end.join("\n")
    end

    def agents_with_missions_sorted_by_mission_count
      Agent.left_joins(:missions)
           .group(:id)
           .order(Arel.sql("COUNT(missions.id) DESC"), :codename)
           .map do |agent|
        count = agent.missions.count
        missions = agent.missions.order(:title).pluck(:title)
        "#{agent.codename} (#{count}): #{missions.join(', ')}"
      end.join("\n")
    end

    def agents_with_skills
      Agent.order(:codename).map do |agent|
        skills = agent.skills.order(:name).pluck(:name)
        "#{agent.codename}: #{skills.join(', ')}"
      end.join("\n")
    end

    def skills_by_agent_count
      Skill.joins(:agents)
           .group(:id)
           .order(Arel.sql("COUNT(agents.id) DESC"), :name)
           .map do |skill|
        agents = skill.agents.order(:codename).pluck(:codename)
        "#{skill.name} (#{agents.size}): #{agents.join(', ')}"
      end.join("\n")
    end
  end
end