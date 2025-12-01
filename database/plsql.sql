-- #############################
-- MEGACORPORATIONS
-- #############################

-- #############################
-- CREATE Megacorporation
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateMegacorporation;

DELIMITER //
CREATE PROCEDURE sp_CreateMegacorporation(
    IN m_name VARCHAR(60),
    IN m_industry VARCHAR(60),
    OUT m_id INT)
BEGIN
    INSERT INTO Megacorporations (name, industry) 
    VALUES (m_name, m_industry);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into m_id;
    -- Display the ID of the last inserted megacorp.
    SELECT LAST_INSERT_ID() AS 'new_id';

END //
DELIMITER ;

-- #############################
-- UPDATE Megacorporation
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateMegacorporation;

DELIMITER //
CREATE PROCEDURE sp_UpdateMegacorporation(IN m_id INT, IN m_name VARCHAR(60), IN m_industry VARCHAR(60))

BEGIN
    UPDATE Megacorporations SET name = m_name, industry = m_industry WHERE megacorp_id = m_id; 
END //
DELIMITER ;

-- #############################
-- DELETE Megacorporation
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteMegacorporation;

DELIMITER //
CREATE PROCEDURE sp_DeleteMegacorporation(IN m_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Megacorporations table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM MegacorporationsHasLocations WHERE Megacorporations_megacorp_id = m_id;
        DELETE FROM Megacorporations WHERE megacorp_id = m_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Megacorporations for id: ', m_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;









-- #############################
-- BREACHES
-- #############################

-- #############################
-- CREATE Breach
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateBreach;

DELIMITER //
CREATE PROCEDURE sp_CreateBreach(
    IN b_date_of_breach DATETIME,
    IN b_ongoing TINYINT(4),
    IN b_hack_type VARCHAR(60),
    IN b_severity_level VARCHAR(60),
    IN b_success TINYINT(4),
    IN b_mcorp_target INT(11),
    OUT b_id INT)
BEGIN
    INSERT INTO Breaches (date_of_breach, ongoing, hack_type, severity_level, success, Megacorporations_megacorp_id) 
    VALUES (b_date_of_breach, b_ongoing, b_hack_type, b_severity_level, b_success, b_mcorp_target);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into b_id;
    -- Display the ID of the last inserted megacorp.
    SELECT LAST_INSERT_ID() AS 'new_id';

END //
DELIMITER ;

-- #############################
-- UPDATE Breach
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateBreach;

DELIMITER //
CREATE PROCEDURE sp_UpdateBreach(   IN b_id INT, 
                                    IN b_date_of_breach DATETIME, 
                                    IN b_ongoing TINYINT(4),
                                    IN b_hack_type VARCHAR(60),
                                    IN b_severity_level VARCHAR(60),
                                    IN b_success TINYINT(4),
                                    IN b_mcorp_target INT(11)
)

BEGIN
    UPDATE Breaches SET date_of_breach = b_date_of_breach,
                        ongoing = b_ongoing,
                        hack_type = b_hack_type,
                        severity_level = b_severity_level,
                        success = b_success,
                        Megacorporations_megacorp_id = b_mcorp_target

                        WHERE breach_id = b_id; 
END //
DELIMITER ;



-- #############################
-- DELETE Breach
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteBreach;

DELIMITER //
CREATE PROCEDURE sp_DeleteBreach(IN b_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from Breaches table and 
        --      intersection tables:    BreachesHasCyberagents,
        --                              assetshasbreaches 
        --      to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        DELETE FROM BreachesHasCyberAgents WHERE Breaches_breach_id = b_id;
        DELETE FROM AssetsHasBreaches WHERE Breaches_breach_id = b_id;
        DELETE FROM Breaches WHERE breach_id = b_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Breaches for id: ', b_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;























































-- #############################
-- MEGACORPORATIONS HAS LOCATIONS
-- #############################

-- Citation for sp_CreateMegacorporationsHasLocations and sp_UpdateMegacorporationsHasLocations:
-- Date: 11/26/2025
-- Based on sp_CreateMegacorporation, sp_UpdateMegacorporation and sp_DeletMegacorporation

-- #############################
-- CREATE MegacorporationsHasLocations
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateMegacorporationsHasLocations;

DELIMITER //
CREATE PROCEDURE sp_CreateMegacorporationsHasLocations(
    IN m_megacorp_id INT,
    IN l_location_id INT
    )
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;

        IF EXISTS(
            SELECT 1
            FROM    MegacorporationsHasLocations
            WHERE   Megacorporations_megacorp_id = m_megacorp_id
                AND Locations_location_id = l_location_id    
        )   THEN
            SET error_message = CONCAT('This megacorporation/location relationship already exists.');
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

        INSERT INTO MegacorporationsHasLocations (Megacorporations_megacorp_id, Locations_location_id) 
        VALUES (m_megacorp_id, l_location_id);

    COMMIT;

END //
DELIMITER ;

-- #############################
-- UPDATE MegacorporationsHasLocations
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateMegacorporationsHasLocations;

DELIMITER //
CREATE PROCEDURE sp_UpdateMegacorporationsHasLocations(
    IN old_megacorp_id INT,
    IN old_location_id INT,
    IN new_megacorp_id INT,
    IN new_location_id INT
    )

BEGIN
    UPDATE MegacorporationsHasLocations
    SET
        Megacorporations_megacorp_id = new_megacorp_id,
        Locations_location_id = new_location_id
    WHERE
        Megacorporations_megacorp_id = old_megacorp_id AND Locations_location_id = old_location_id;  
END //
DELIMITER ;

-- #############################
-- DELETE MegacorporationsHasLocations
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteMegacorporationsHasLocations;

DELIMITER //
CREATE PROCEDURE sp_DeleteMegacorporationsHasLocations(
    IN m_megacorp_id INT,
    IN l_location_id INT
    )
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Megacorporations table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM MegacorporationsHasLocations
        WHERE Megacorporations_megacorp_id = m_megacorp_id AND Locations_location_id = l_location_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in MegacorporationsHasLocations for Megacorporation ID: ', m_megacorp_id, ' and Location ID: ', l_location_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;































