-- Active: 1747464944307@@localhost@5432@conservation_db
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(150) NOT NULL
);

INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(200) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    location VARCHAR(50) NOT NULL,
    sighting_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    notes TEXT
);

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;

-- Problem 01
INSERT INTO rangers (name, region) VALUES
('Derek Fox', 'Coastal Plains');

-- Problem 02
SELECT COUNT(DISTINCT species_id) AS unique_species_count 
FROM sightings;

-- Problem 03
SELECT *
FROM sightings
WHERE location LIKE '%Pass%';

-- Problem 04
SELECT r.name,
       COUNT(s.sighting_id) AS total_sightings
FROM rangers AS r INNER JOIN 
     sightings AS s 
USING(ranger_id)
GROUP BY r.name
ORDER BY r.name ASC;

-- Problem 05
SELECT s.common_name
FROM species AS s LEFT JOIN 
     sightings AS si
USING(species_id)
WHERE si.sighting_id IS NULL;

-- Problem 06
SELECT s.common_name,
       si.sighting_time,
       r.name   
FROM sightings AS si INNER JOIN 
     species AS s USING(species_id) INNER JOIN
     rangers AS r USING(ranger_id)
ORDER BY sighting_time DESC
LIMIT 2;

-- Problem 07
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

-- Problem 08 - Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
-- Morning: before 12 PM
-- Afternoon: 12 PM–5 PM
-- Evening: after 5 PM


-- Problem 09
DELETE
FROM rangers AS r 
WHERE r.ranger_id IN (
    SELECT ranger_id 
    FROM rangers AS r LEFT JOIN 
         sightings AS s
    USING(ranger_id)
    WHERE s.sighting_id IS NULL
);
