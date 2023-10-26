-- add comments 
COMMENT on  ROLE aplicacao is 'this roles has only select';

SELECT rolname as USER, description AS comment FROM pg_roles r JOIN pg_shdescription c ON c.objoid = r.oid;
               
--count users in a role
               WITH RECURSIVE membership_tree(grpid, userid) AS (
               -- Get all roles and list them as their own group as well
               SELECT pg_roles.oid, pg_roles.oid
               FROM pg_roles
               UNION ALL
               -- Now add all group membership
               SELECT m_1.roleid, t_1.userid
               FROM pg_auth_members m_1, membership_tree t_1
               WHERE m_1.member = t_1.grpid
               )
               SELECT DISTINCT t.userid, r.rolname AS usrname, t.grpid, m.rolname AS grpname
               FROM membership_tree t, pg_roles r, pg_roles m
               WHERE t.grpid = m.oid AND t.userid = r.oid and t.grpid = 19202 -- filter by role id
               ORDER BY r.rolname, m.rolname; 

--list all roles grant for user
SELECT oid, rolname FROM pg_roles where pg_has_role( 'user', oid, 'member');
