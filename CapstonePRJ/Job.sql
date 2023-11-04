MERGE INTO RATINGS rt
USING (select c.CATEGORY_ID as categ, sum(w.VIEW_COUNT) as total
       from VIDEOS v
                inner join CATEGORY c on v.CATEGORY_ID = c.CATEGORY_ID
                inner join VIEWS w on v.VIDEO_ID = w.VIDEO_ID
       group by c.CATEGORY_ID
       order by total desc) counter
ON (rt.CATEGORY_ID = counter.categ)
WHEN MATCHED THEN
    UPDATE
    SET rt.TOTAL_VIEW_COUNT = counter.total
WHEN NOT MATCHED THEN
    INSERT (category_id, total_view_count)
    VALUES (categ, total);
commit;

BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
            job_name => 'WEEKLY_RATINGS_MERGE',
            job_type => 'PLSQL_BLOCK',
            job_action => '
      BEGIN
        MERGE INTO RATINGS rt
        USING (select c.CATEGORY_ID as categ, sum(w.VIEW_COUNT) as total
               from VIDEOS v
                        inner join CATEGORY c on v.CATEGORY_ID = c.CATEGORY_ID
                        inner join VIEWS w on v.VIDEO_ID = w.VIDEO_ID
               group by c.CATEGORY_ID
               order by total desc) counter
        ON (rt.CATEGORY_ID = counter.categ)
        WHEN MATCHED THEN
            UPDATE
            SET rt.TOTAL_VIEW_COUNT = counter.total;
      END;',
            start_date => SYSTIMESTAMP,
            repeat_interval => 'FREQ=WEEKLY;BYDAY=MON',
            end_date => NULL,
            enabled => TRUE);
END;
/
commit;

BEGIN
    DBMS_SCHEDULER.DROP_JOB(
            job_name => 'DELETE_LESS_FOLLOWED_JOB',
            force => FALSE
    );
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
            job_name => 'DELETE_LESS_FOLLOWED_JOB',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin USER_FEATURES.DELETE_LESS_FOLLOWED(80000); commit; end;',
            start_date => SYSTIMESTAMP,
            repeat_interval => 'FREQ=YEARLY; INTERVAL=6; BYMONTH=JAN;',
            end_date => NULL,
            enabled => TRUE,
            comments => 'Job to delete less followed videos every 6 months'
    );
END;
/

SELECT * FROM USER_SCHEDULER_JOBS;



