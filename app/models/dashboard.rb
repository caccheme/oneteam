class Dashboard < ActiveRecord::Base

  def select_all(query)
    ActiveRecord::Base.connection.select_all(query)
  end

  def request_report
    select_all("SELECT strftime('%m-%Y', req.created_at) date, req.title title, 
               req.location_id req_location, e.location_id emp_location, e.first_name first_name, 
               e.last_name last_name
               FROM Requests req
               LEFT OUTER JOIN Responses res ON res.request_id = req.id
               LEFT OUTER JOIN Commissions c ON c.response_id = res.id
               LEFT OUTER JOIN Employees e ON e.id = res.employee_id
               ORDER BY req_location ")
  end

  def request_summary
    select_all("SELECT strftime('%Y-%m', req.created_at) month, 
                COUNT(DISTINCT req.id) num_reqs, COUNT(req.status='cancelled') num_cancelled,
                COUNT(DISTINCT res.request_id) num_w_resps, COUNT(DISTINCT c.response_id) num_w_coms
                FROM Requests req
                LEFT OUTER JOIN Responses res
                ON req.id = res.request_id
                LEFT OUTER JOIN Commissions c
                ON c.response_id = res.id
                GROUP BY month")
  end

  def requests_filled
    select_all("SELECT SUM(t1.diff<=1) one, SUM(t1.diff > 1 and t1.diff <= 3) one_to_three, 
                SUM(t1.diff >3 and t1.diff <= 6) three_to_six, SUM(t1.diff > 6) six
                FROM
                (SELECT julianday(c.created_at) - julianday(req.created_at) diff
                FROM Commissions c, Responses res, Requests req
                WHERE req.id = res.request_id AND c.response_id = res.id ) t1")
  end

  def developer_interests
    select_all("SELECT s.id skill, s.language skillname,
                SUM(CASE WHEN e.location_id=1 THEN 1 ELSE 0 END) chicago,
                SUM(CASE WHEN e.location_id=2  THEN 1 ELSE 0 END) mumbai,
                SUM(CASE WHEN e.location_id=3 THEN 1 ELSE 0 END) houston,
                SUM(CASE WHEN e.location_id=4 THEN 1 ELSE 0 END) boston,
                SUM(CASE WHEN e.location_id=5 THEN 1 ELSE 0 END) sanfrancisco,
                SUM(CASE WHEN e.location_id=6 THEN 1 ELSE 0 END) london
                FROM Desired_skills ds, Skills s, Employees e
                ON ds.skill_id = s.id AND ds.employee_id = e.id
                WHERE ds.level != 0
                GROUP BY skill ORDER BY skill")
  end

  def avg_skills
    select_all("SELECT s.id skill, s.language skillname,
                ROUND(AVG(CASE WHEN e.location_id=1 THEN ds.level ELSE null END),1) chicago,
                ROUND(AVG(CASE WHEN e.location_id=2 THEN ds.level ELSE null END),1) mumbai,
                ROUND(AVG(CASE WHEN e.location_id=3 THEN ds.level ELSE null END),1) houston,
                ROUND(AVG(CASE WHEN e.location_id=4 THEN ds.level ELSE null END),1) boston,
                ROUND(AVG(CASE WHEN e.location_id=5 THEN ds.level ELSE null END),1) sanfrancisco, 
                ROUND(AVG(CASE WHEN e.location_id=6 THEN ds.level ELSE null END),1) london
                FROM Developer_skills ds, Skills s, Employees e
                ON ds.skill_id = s.id AND ds.employee_id = e.id
                WHERE ds.level != 0
                GROUP BY skill ORDER BY skill")
  end

  def offices_impact
    select_all("SELECT e.first_name fname, e.last_name lname, e.id dev, c.created_at date,
      COUNT(CASE WHEN strftime('%m', c.created_at) = strftime('%m', DATE('now', '-5 month')) THEN req.location_id END) month1,
      COUNT(CASE WHEN strftime('%m', c.created_at) = strftime('%m', DATE('now', '-4 month')) THEN req.location_id END) month2,
      COUNT(CASE WHEN strftime('%m', c.created_at) = strftime('%m', DATE('now', '-3 month')) THEN req.location_id END) month3,
      COUNT(CASE WHEN strftime('%m', c.created_at) = strftime('%m', DATE('now', '-2 month')) THEN req.location_id END) month4,
      COUNT(CASE WHEN strftime('%m', c.created_at) = strftime('%m', DATE('now', '-1 month')) THEN req.location_id END) month5,
      COUNT(CASE WHEN strftime('%m', c.created_at) = DATE('now') THEN req.location_id END) month6
      FROM Employees e, Commissions c, Requests req
      ON e.id = c.employee_id AND req.id = c.request_id
      GROUP BY dev ORDER BY dev")
  end

  def six_month_developers_impact
    select_all("SELECT  strftime('%Y-%m', req.start_date) date,
      COUNT(CASE WHEN req.location_id = 1 THEN e.location_id END) chicago,
      COUNT(CASE WHEN req.location_id = 2 THEN e.location_id END) mumbai,
      COUNT(CASE WHEN req.location_id = 3 THEN e.location_id END) houston,
      COUNT(CASE WHEN req.location_id = 4 THEN e.location_id END) boston,
      COUNT(CASE WHEN req.location_id = 5 THEN e.location_id END) sanfran,
      COUNT(CASE WHEN req.location_id = 6 THEN e.location_id END) london
      FROM Employees e LEFT OUTER JOIN Commissions c ON c.employee_id = e.id  
      LEFT OUTER JOIN Requests req ON req.employee_id = e.id
      WHERE e.location_id = req.location_id
      GROUP BY date
      ORDER BY date")
  end
   	
end