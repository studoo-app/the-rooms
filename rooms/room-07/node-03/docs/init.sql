-- ============================================
-- THE ROOMS - SQL Injection Challenge
-- Operation Rabbit Hole - Database Setup
-- Room 5: Injection SQL
-- ============================================
-- Auteur: Nours
-- Description: Configuration de 3 bases de données pour exercice pédagogique
-- FLAG: Caché dans la base recettes_db (encodage binaire)
-- ============================================

-- Création des utilisateurs avec mots de passe sécurisés
CREATE USER IF NOT EXISTS 'citations_user'@'%' IDENTIFIED BY 'philo2024!SecureP@ss';
CREATE USER IF NOT EXISTS 'blagues_user'@'%' IDENTIFIED BY 'rire2024!FunnyP@ss';
CREATE USER IF NOT EXISTS 'recettes_user'@'%' IDENTIFIED BY 'cuisine2024!ChefP@ss';

-- ============================================
-- BASE 1: Citations Philosophiques (SITE WEB)
-- ============================================
CREATE DATABASE IF NOT EXISTS citations_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE citations_db;

CREATE TABLE citations (
   id INT AUTO_INCREMENT PRIMARY KEY,
   auteur VARCHAR(100) NOT NULL,
   citation TEXT NOT NULL,
   epoque VARCHAR(50),
   theme VARCHAR(50),
   annee INT,
   INDEX idx_auteur (auteur),
   INDEX idx_theme (theme)
);

-- Philosophie Antique
INSERT INTO citations (auteur, citation, epoque, theme, annee) VALUES
   ('Socrate', 'Connais-toi toi-même', 'Antiquité', 'Sagesse', -400),
   ('Socrate', 'Tout ce que je sais, c''est que je ne sais rien', 'Antiquité', 'Connaissance', -399),
   ('Socrate', 'Une vie sans examen ne vaut pas la peine d''être vécue', 'Antiquité', 'Réflexion', -399),
   ('Platon', 'La nécessité est mère de l''invention', 'Antiquité', 'Créativité', -380),
   ('Platon', 'Le prix que les hommes bons paient pour leur indifférence aux affaires publiques est d''être gouvernés par des hommes mauvais', 'Antiquité', 'Politique', -375),
   ('Platon', 'La musique donne une âme à nos cœurs et des ailes à la pensée', 'Antiquité', 'Art', -370),
   ('Aristote', 'Le tout est plus que la somme de ses parties', 'Antiquité', 'Métaphysique', -350),
   ('Aristote', 'L''homme est par nature un animal politique', 'Antiquité', 'Politique', -340),
   ('Aristote', 'C''est dans l''effort que l''on trouve la satisfaction et non dans la réussite', 'Antiquité', 'Effort', -335),
   ('Aristote', 'Le sage ne dit pas ce qu''il sait, le sot ne sait pas ce qu''il dit', 'Antiquité', 'Sagesse', -330),
   ('Épicure', 'Le sage vit content de peu', 'Antiquité', 'Bonheur', -300),
   ('Épicure', 'La mort n''est rien pour nous', 'Antiquité', 'Mort', -295),
   ('Épicure', 'Il vaut mieux être malheureux et sage qu''heureux et sot', 'Antiquité', 'Sagesse', -290),
   ('Sénèque', 'Ce n''est pas parce que les choses sont difficiles que nous n''osons pas, c''est parce que nous n''osons pas qu''elles sont difficiles', 'Antiquité', 'Courage', 50),
   ('Sénèque', 'La vie, ce n''est pas d''attendre que l''orage passe, c''est d''apprendre à danser sous la pluie', 'Antiquité', 'Résilience', 55),
   ('Marc Aurèle', 'Que la force me soit donnée de supporter ce qui ne peut être changé et le courage de changer ce qui peut l''être mais aussi la sagesse de distinguer l''un de l''autre', 'Antiquité', 'Stoïcisme', 170),
   ('Descartes', 'Je pense, donc je suis', 'Moderne', 'Métaphysique', 1637),
   ('Descartes', 'Le bon sens est la chose du monde la mieux partagée', 'Moderne', 'Raison', 1637),
   ('Descartes', 'Pour atteindre la vérité, il faut une fois dans sa vie se défaire de toutes les opinions qu''on a reçues', 'Moderne', 'Vérité', 1641),
   ('Pascal', 'Le cœur a ses raisons que la raison ne connaît point', 'Moderne', 'Foi', 1670),
   ('Pascal', 'L''homme n''est qu''un roseau, le plus faible de la nature, mais c''est un roseau pensant', 'Moderne', 'Humanité', 1670),
   ('Pascal', 'Nous ne nous tenons jamais au temps présent', 'Moderne', 'Temps', 1669),
   ('Spinoza', 'La liberté est la nécessité comprise', 'Moderne', 'Liberté', 1677),
   ('Spinoza', 'La paix n''est pas l''absence de guerre, c''est une vertu, un état d''esprit, une volonté de bienveillance, de confiance, de justice', 'Moderne', 'Paix', 1677),
   ('Leibniz', 'Le présent est gros de l''avenir', 'Moderne', 'Temps', 1710),
   ('Rousseau', 'L''homme est né libre, et partout il est dans les fers', 'Moderne', 'Liberté', 1762),
   ('Rousseau', 'La nature a fait l''homme heureux et bon, mais la société le déprave et le rend misérable', 'Moderne', 'Société', 1755),
   ('Kant', 'Agis de telle sorte que tu traites l''humanité toujours comme une fin, et jamais simplement comme un moyen', 'Moderne', 'Éthique', 1785),
   ('Kant', 'Sapere aude ! Aie le courage de te servir de ton propre entendement', 'Moderne', 'Lumières', 1784),
   ('Kant', 'La science est une connaissance organisée. La sagesse est une vie organisée', 'Moderne', 'Sagesse', 1790),
   ('Hegel', 'Tout ce qui est réel est rationnel, tout ce qui est rationnel est réel', 'Moderne', 'Raison', 1820),
   ('Nietzsche', 'Ce qui ne me tue pas me rend plus fort', 'Contemporaine', 'Volonté', 1888),
   ('Nietzsche', 'Deviens ce que tu es', 'Contemporaine', 'Identité', 1882),
   ('Nietzsche', 'Il faut avoir du chaos en soi pour accoucher d''une étoile qui danse', 'Contemporaine', 'Création', 1883),
   ('Nietzsche', 'Sans la musique, la vie serait une erreur', 'Contemporaine', 'Art', 1889),
   ('Sartre', 'L''existence précède l''essence', 'Contemporaine', 'Existentialisme', 1946),
   ('Sartre', 'L''enfer, c''est les autres', 'Contemporaine', 'Autrui', 1944),
   ('Sartre', 'Nous sommes nos choix', 'Contemporaine', 'Liberté', 1943),
   ('Camus', 'Il faut imaginer Sisyphe heureux', 'Contemporaine', 'Absurde', 1942),
   ('Camus', 'La vraie générosité envers l''avenir consiste à tout donner au présent', 'Contemporaine', 'Générosité', 1951),
   ('Simone de Beauvoir', 'On ne naît pas femme, on le devient', 'Contemporaine', 'Féminisme', 1949),
   ('Foucault', 'Le pouvoir, ce n''est pas une institution, et ce n''est pas une structure, ce n''est pas une certaine puissance dont certains seraient dotés', 'Contemporaine', 'Pouvoir', 1976),
   ('Deleuze', 'L''important n''est jamais de commencer ou de finir, l''important c''est le milieu', 'Contemporaine', 'Processus', 1980),
   ('Wittgenstein', 'Les limites de mon langage sont les limites de mon monde', 'Contemporaine', 'Langage', 1921),
   ('Hannah Arendt', 'La banalité du mal', 'Contemporaine', 'Mal', 1963);

GRANT SELECT ON citations_db.* TO 'citations_user'@'%';

-- ============================================
-- BASE 2: Blagues de Tonton (DISTRACTION)
-- ============================================
CREATE DATABASE IF NOT EXISTS blagues_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE blagues_db;

CREATE TABLE blagues (
     id INT AUTO_INCREMENT PRIMARY KEY,
     categorie VARCHAR(50),
     blague TEXT NOT NULL,
     note_humour INT DEFAULT 5,
     date_ajout DATE,
     INDEX idx_categorie (categorie)
);

INSERT INTO blagues (categorie, blague, note_humour, date_ajout) VALUES
-- Blagues Geek/Informatique
('Geek', 'Pourquoi les développeurs préfèrent-ils le dark mode ? Parce que la lumière attire les bugs !', 8, '2024-01-15'),
('Geek', 'Comment appelle-t-on un développeur qui sort ? Un bug dans la matrice !', 7, '2024-01-16'),
('Geek', 'Pourquoi les programmeurs confondent-ils Halloween et Noël ? Parce que 31 OCT = 25 DEC !', 9, '2024-01-17'),
('Geek', 'Un informaticien, ça compte : 0, 1, 2... beaucoup !', 6, '2024-01-18'),
('Geek', 'Quelle est la blague préférée des développeurs ? undefined !', 8, '2024-01-19'),
('Geek', 'Pourquoi les développeurs n''aiment pas la nature ? Trop de bugs et pas assez de documentation !', 7, '2024-01-20'),
('Geek', 'Comment savoir qu''un dev est extraverti ? Il regarde VOS chaussures quand il vous parle !', 7, '2024-01-21'),

-- Blagues Réseau/Cybersécurité
('Réseau', 'C''est quoi un ping-pong entre hackers ? Un ICMP echo request/reply !', 7, '2024-01-22'),
('Réseau', 'Pourquoi le routeur est-il allé chez le psy ? Il avait trop de paquets perdus !', 6, '2024-01-23'),
('Réseau', 'Comment appelle-t-on un administrateur réseau sans WiFi ? Déconnecté de la réalité !', 7, '2024-01-24'),
('Réseau', 'Quelle est la boisson préférée d''un admin réseau ? Le port !', 5, '2024-01-25'),
('Réseau', 'Pourquoi le firewall est-il déprimé ? Tout le monde le bloque !', 6, '2024-01-26'),

-- Blagues SQL/Bases de données
('SQL', 'Un SQL query entre dans un bar, s''approche de deux tables et demande : "Je peux vous JOIN ?"', 9, '2024-01-27'),
('SQL', 'Qu''est-ce qu''un DBA pessimiste ? Un gars qui fait des ROLLBACK même dans la vie !', 7, '2024-01-28'),
('SQL', 'Pourquoi les DBAs n''aiment pas les blagues ? Elles ne respectent pas l''intégrité référentielle !', 6, '2024-01-29'),
('SQL', 'Comment un DBA drague-t-il ? "Tu veux voir ma clé primaire ?"', 5, '2024-01-30'),
('SQL', 'Quelle est la requête préférée d''un DBA alcoolique ? SELECT * FROM bar WHERE date = CURRENT_DATE', 8, '2024-01-31'),

-- Blagues Sécurité/Hacking
('Sécurité', 'Pourquoi le hacker est-il allé au bar ? Pour tester les injections !', 6, '2024-02-01'),
('Sécurité', 'Comment appelle-t-on un hacker qui dort ? Un exploit de nuit !', 5, '2024-02-02'),
('Sécurité', 'Quelle est la boisson préférée d''un pentester ? Le port scan !', 7, '2024-02-03'),
('Sécurité', 'Pourquoi les hackers font-ils de bons jardiniers ? Ils excellent dans les root kits !', 8, '2024-02-04'),
('Sécurité', 'Comment un hacker déclare-t-il sa flamme ? "Tu as pwned mon cœur !"', 6, '2024-02-05'),
('Sécurité', 'Pourquoi le hacker est-il végétarien ? Il préfère les salades aux cookies !', 7, '2024-02-06'),

-- Blagues Cloud/DevOps
('Cloud', 'Le cloud, c''est juste l''ordinateur de quelqu''un d''autre... avec une jolie facture !', 8, '2024-02-07'),
('Cloud', 'Comment appelle-t-on un DevOps sans Docker ? Perdu !', 7, '2024-02-08'),
('Cloud', 'Pourquoi les DevOps aiment-ils le café ? Parce que sans Java, ils ne peuvent pas démarrer !', 6, '2024-02-09'),
('Cloud', 'Quelle est la devise d''un admin cloud ? "Ça marche sur ma machine... virtuelle !"', 8, '2024-02-10'),

-- Blagues Générales IT
('IT', 'Pourquoi les informaticiens ont-ils des lunettes ? Parce qu''ils ne voient pas bien les interfaces !', 5, '2024-02-11'),
('IT', 'Comment répare-t-on un ordinateur cassé ? Avec du Ctrl+Alt+Delete !', 4, '2024-02-12'),
('IT', 'Quelle est la différence entre un informaticien et un terroriste ? On peut négocier avec un terroriste !', 7, '2024-02-13'),
('IT', 'Combien faut-il d''informaticiens pour changer une ampoule ? Aucun, c''est un problème hardware !', 6, '2024-02-14'),
('IT', 'Pourquoi les informaticiens détestent-ils la nature ? Trop de bugs et pas de Ctrl+Z !', 7, '2024-02-15'),

-- Blagues Meta (sur les bases de données elles-mêmes)
('Meta', 'Pourquoi cette base de données existe-t-elle ? Pour distraire les étudiants pendant qu''ils cherchent le flag ailleurs !', 9, '2024-02-16'),
('Meta', 'Conseil de pro : Le flag n''est PAS dans cette table... ou peut-être que si ? (Spoiler: non)', 8, '2024-02-17'),
('Meta', 'Si tu es ici, c''est que tu explores bien ! Mais essaie les autres bases de données...', 7, '2024-02-18');

GRANT SELECT ON blagues_db.* TO 'blagues_user'@'%';

-- ============================================
-- BASE 3: Recettes de Cuisine (FLAG CACHÉ)
-- ============================================
CREATE DATABASE IF NOT EXISTS recettes_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE recettes_db;

CREATE TABLE recettes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_recette VARCHAR(100) NOT NULL,
  ingredients TEXT NOT NULL,
  preparation TEXT NOT NULL,
  temps_cuisson INT COMMENT 'Temps en minutes',
  difficulte VARCHAR(20),
  type_plat VARCHAR(50),
  origine VARCHAR(50),
  INDEX idx_difficulte (difficulte),
  INDEX idx_type (type_plat)
);

-- Recettes Entrées
INSERT INTO recettes (nom_recette, ingredients, preparation, temps_cuisson, difficulte, type_plat, origine) VALUES
    ('Salade César',
     'Laitue romaine, croûtons, parmesan, poulet grillé, sauce César (anchois, huile d''olive, citron, ail, moutarde)',
     'Laver et couper la laitue. Griller le poulet et le découper. Préparer la sauce en mixant anchois, ail, moutarde, citron et huile. Mélanger tous les ingrédients, ajouter croûtons et parmesan.',
     15, 'Facile', 'Entrée', 'États-Unis'),

    ('Soupe à l''oignon',
     'Oignons (1kg), bouillon de bœuf (1L), pain rassis, gruyère râpé, beurre, vin blanc',
     'Émincer les oignons et les faire caraméliser au beurre pendant 30 minutes. Déglacer au vin blanc, ajouter le bouillon. Laisser mijoter 20 minutes. Servir avec pain grillé et fromage gratinés.',
     50, 'Moyen', 'Entrée', 'France'),

    ('Houmous maison',
     'Pois chiches (400g), tahini (3 cuillères), citron, ail (2 gousses), huile d''olive, cumin, paprika',
     'Mixer les pois chiches égouttés avec tahini, jus de citron, ail et un peu d''eau. Assaisonner avec cumin et sel. Servir avec un filet d''huile d''olive et du paprika.',
     10, 'Facile', 'Entrée', 'Moyen-Orient'),

    ('Coq au vin',
     'Coq (ou poulet) découpé, vin rouge (75cl), lardons, champignons, oignons, carottes, bouquet garni, cognac',
     'Faire revenir le poulet avec les lardons. Flamber au cognac. Ajouter vin, légumes et bouquet garni. Laisser mijoter 2 heures à feu doux. Servir avec pommes de terre vapeur.',
     120, 'Difficile', 'Plat principal', 'France'),

    ('Paella valenciana',
     'Riz rond (500g), poulet, lapin, haricots verts, tomates, safran, paprika, huile d''olive, bouillon',
     'Faire revenir les viandes. Ajouter les légumes puis le riz. Incorporer le bouillon avec safran et paprika. Cuire à feu vif puis doux pendant 20 minutes sans remuer.',
     45, 'Moyen', 'Plat principal', 'Espagne'),

    ('Bœuf bourguignon',
     'Bœuf à braiser (1,5kg), vin rouge de Bourgogne (1 bouteille), lardons, carottes, oignons grelots, champignons, bouquet garni',
     'Faire mariner la viande dans le vin 12h. Faire revenir la viande et les lardons. Ajouter la marinade, légumes et bouquet garni. Cuire 3 heures à feu doux.',
     180, 'Difficile', 'Plat principal', 'France'),

    ('Curry de légumes',
     'Légumes variés (carottes, courgettes, poivrons, chou-fleur), lait de coco, pâte de curry, gingembre, ail, coriandre',
     'Faire revenir l''ail et le gingembre. Ajouter la pâte de curry et les légumes coupés. Verser le lait de coco et laisser mijoter 25 minutes. Servir avec riz basmati.',
     35, 'Facile', 'Plat principal', 'Inde'),

    ('Lasagnes bolognaise',
     'Pâtes à lasagne, viande hachée (800g), sauce tomate, béchamel, oignon, ail, vin rouge, parmesan, mozzarella',
     'Préparer la bolognaise en faisant revenir viande, oignon et ail, puis mijoter avec tomate et vin. Monter les lasagnes en alternant pâtes, bolognaise et béchamel. Gratiner au four 40 minutes.',
     90, 'Moyen', 'Plat principal', 'Italie'),

-- Recettes Desserts
    ('Tarte aux pommes',
     'Pâte brisée, 5 pommes, 100g sucre, 50g beurre, cannelle, compote de pommes',
     'Étaler la pâte dans un moule. Étaler une fine couche de compote. Disposer les pommes en rosace, saupoudrer de sucre et cannelle, parsemer de noisettes de beurre. Cuire au four 45 minutes à 180°C.',
     45, 'Facile', 'Dessert', 'France'),

    ('Tiramisu',
     'Mascarpone (500g), œufs (6), sucre (150g), biscuits à la cuillère, café fort, cacao amer, amaretto',
     'Séparer jaunes et blancs d''œufs. Monter les blancs en neige. Mélanger jaunes avec sucre et mascarpone. Incorporer les blancs délicatement. Tremper les biscuits dans le café et monter en couches alternées. Saupoudrer de cacao. Réserver 6h au frais.',
     20, 'Moyen', 'Dessert', 'Italie'),

    ('Crème brûlée',
     'Jaunes d''œufs (8), crème liquide (500ml), sucre (100g + pour caraméliser), gousse de vanille',
     'Faire chauffer la crème avec la vanille. Battre jaunes et sucre. Mélanger avec la crème. Verser dans des ramequins. Cuire au bain-marie 40 minutes à 150°C. Laisser refroidir, saupoudrer de sucre et caraméliser au chalumeau.',
     40, 'Moyen', 'Dessert', 'France'),

    ('Cheesecake new-yorkais',
     'Biscuits digestifs (250g), beurre (100g), cream cheese (600g), sucre (200g), œufs (4), crème fraîche (200ml), extrait de vanille',
     'Écraser les biscuits et mélanger avec le beurre fondu. Tasser au fond d''un moule. Battre le cream cheese avec sucre, œufs, crème et vanille. Verser sur la base. Cuire 1h à 160°C. Laisser refroidir lentement dans le four éteint.',
     60, 'Moyen', 'Dessert', 'États-Unis'),

    ('Mousse au chocolat',
     'Chocolat noir (200g), œufs (6), sucre (50g), pincée de sel',
     'Faire fondre le chocolat au bain-marie. Séparer blancs et jaunes. Mélanger les jaunes au chocolat fondu. Monter les blancs en neige ferme avec le sel. Incorporer délicatement au chocolat. Réfrigérer 4 heures.',
     10, 'Facile', 'Dessert', 'France'),

-- Recettes Pâtisserie
    ('Croissants maison',
     'Farine (500g), beurre (250g), lait (200ml), levure de boulanger, sucre (50g), sel (10g), œuf pour dorure',
     'Préparer la détrempe avec farine, lait, levure, sucre et sel. Laisser reposer. Incorporer le beurre par tourage (6 tours simples). Découper en triangles, rouler et façonner. Laisser pousser 2h. Dorer et cuire 15 minutes à 200°C.',
     180, 'Expert', 'Pâtisserie', 'France'),

    ('Macarons parisiens',
     'Poudre d''amande (125g), sucre glace (200g), blancs d''œufs (100g), sucre (200g), eau (50ml), colorant alimentaire',
     'Tamiser amande et sucre glace. Monter les blancs. Préparer un sirop à 118°C et le verser sur les blancs. Macaronner la pâte. Dresser sur plaque, laisser croûter 30 min. Cuire 12 min à 150°C.',
     180, 'Expert', 'Pâtisserie', 'France'),

-- RECETTE AVEC LE FLAG (encodé en binaire)
    ('Gâteau du Lapin Blanc',
     '1010100 1101000 1100101 100000 1110000 1100001 1110011 1110011 1110111 1101111 1110010 1100100 100000 1111001 1101111 1110101 100000 1101100 1101111 1101111 1101011 1101001 1101110 1100111 100000 1100110 1101111 1110010 100000 1101001 1110011 100000 111010 100000 1111001 1010010 1110110 110111 1001100 1000010 1110100 1100101 110110 1110010 1000101 110100 1111010 1111000 1101110 1011001','Cette recette mystérieuse du Pays des Merveilles nécessite une conversion binaire vers ASCII pour révéler ses véritables ingrédients. Le Lapin Blanc était toujours pressé, tout comme vous devriez l''être pour décoder ce message avant que le temps ne s''écoule. Suivez Alice dans le terrier... Les ingrédients sont encodés en binaire (8 bits par caractère). Une fois décodés, ils révéleront un secret bien gardé. Temps de cuisson symbolique : 42 minutes, le nombre de la réponse à la grande question sur la vie, l''univers et le reste. Difficulté : Expert en décodage.',
     42, 'Expert', 'Pâtisserie', 'Pays des Merveilles'),

-- Autres recettes pour noyer le flag
    ('Quiche Lorraine',
     'Pâte brisée, 200g lardons fumés, 3 œufs, 200ml crème fraîche épaisse, 100g gruyère râpé, muscade, poivre',
     'Étaler la pâte dans un moule à tarte. Piquer le fond à la fourchette. Faire revenir les lardons sans matière grasse. Battre les œufs avec la crème, ajouter le fromage et assaisonner. Répartir les lardons sur la pâte, verser l''appareil. Cuire 35 minutes à 180°C.',
     35, 'Facile', 'Plat principal', 'France'),

    ('Ratatouille provençale',
     'Aubergines (2), courgettes (3), poivrons rouges (2), tomates (6), oignons (2), ail (4 gousses), herbes de Provence, huile d''olive',
     'Couper tous les légumes en dés réguliers. Faire revenir séparément chaque légume à l''huile d''olive. Dans une cocotte, mélanger tous les légumes avec l''ail haché et les herbes. Laisser mijoter à feu doux pendant 45 minutes en remuant régulièrement.',
     60, 'Moyen', 'Plat principal', 'France'),

    ('Crêpes bretonnes',
     'Farine (250g), œufs (4), lait (500ml), beurre fondu (50g), sucre (2 cuillères), pincée de sel, rhum (facultatif)',
     'Mélanger la farine, les œufs et une pincée de sel. Incorporer progressivement le lait en fouettant pour éviter les grumeaux. Ajouter le beurre fondu et le sucre. Laisser reposer 1h. Faire cuire les crêpes dans une poêle chaude légèrement huilée.',
     30, 'Facile', 'Dessert', 'France'),

    ('Risotto aux champignons',
     'Riz arborio (300g), champignons variés (400g), bouillon de volaille (1L), vin blanc (100ml), oignon, parmesan (100g), beurre, persil',
     'Faire revenir l''oignon émincé. Ajouter le riz et nacrer 2 minutes. Déglacer au vin blanc. Ajouter le bouillon louche par louche en remuant constamment. À mi-cuisson, incorporer les champignons revenus. Terminer avec beurre et parmesan.',
     35, 'Moyen', 'Plat principal', 'Italie'),

    ('Tarte au citron meringuée',
     'Pâte sablée, citrons (4), œufs (6), sucre (200g), beurre (100g), maïzena (30g)',
     'Cuire la pâte à blanc. Préparer la crème citron : mélanger jus de citron, zeste, jaunes d''œufs, sucre et maïzena. Cuire à feu doux jusqu''à épaississement. Incorporer le beurre. Verser sur la pâte. Monter les blancs en neige avec sucre, déposer sur la crème. Dorer au four 5 minutes.',
     50, 'Moyen', 'Dessert', 'France'),

    ('Pad Thaï',
     'Nouilles de riz, crevettes, tofu, œufs, germes de soja, cacahuètes, ciboulette, sauce soja, sauce poisson, tamarin, sucre de palme',
     'Faire tremper les nouilles. Faire revenir crevettes et tofu. Ajouter œufs brouillés, nouilles égouttées et sauces. Mélanger à feu vif. Ajouter germes de soja et ciboulette. Servir avec cacahuètes concassées et quartier de citron vert.',
     25, 'Moyen', 'Plat principal', 'Thaïlande'),

    ('Fondant au chocolat',
     'Chocolat noir (200g), beurre (200g), œufs (4), sucre (150g), farine (50g)',
     'Faire fondre chocolat et beurre ensemble. Battre œufs et sucre jusqu''à ce que le mélange blanchisse. Incorporer le chocolat fondu puis la farine tamisée. Verser dans des moules individuels beurrés. Cuire 12 minutes à 180°C pour un cœur coulant.',
     12, 'Facile', 'Dessert', 'France');

GRANT SELECT ON recettes_db.* TO 'recettes_user'@'%';

-- ============================================
-- Permissions et finalisation
-- ============================================
FLUSH PRIVILEGES;

-- ============================================
-- INFORMATIONS DE DÉBOGAGE
-- ============================================
-- Décommenter pour le debug (NE PAS utiliser en production)
-- SELECT 'Utilisateurs créés:' AS Info;
-- SELECT User, Host FROM mysql.user WHERE User LIKE '%_user';
-- SELECT 'Bases de données créées:' AS Info;
-- SHOW DATABASES;
-- SELECT 'Nombre d''enregistrements par table:' AS Info;
-- SELECT 'citations_db' AS Base, COUNT(*) AS Nb_enregistrements FROM citations_db.citations
-- UNION ALL
-- SELECT 'blagues_db', COUNT(*) FROM blagues_db.blagues
-- UNION ALL
-- SELECT 'recettes_db', COUNT(*) FROM recettes_db.recettes;

-- ============================================
-- NOTES PÉDAGOGIQUES
-- ============================================
-- FLAG: ROOM_5{D0wn_th3_R4bb1t_H0l3}
-- Encodage: Binaire (8 bits par caractère ASCII)
--
-- Scénario d'exploitation attendu:
-- 1. Injection SQL sur le formulaire de recherche de citations
-- 2. Énumération des bases via information_schema
-- 3. Exploration de blagues_db (distraction)
-- 4. Découverte de recettes_db
-- 5. Identification de la recette suspecte "Gâteau du Lapin Blanc"
-- 6. Décodage binaire → ASCII pour récupérer le flag
--
-- Indices cachés dans la base:
-- - Référence à Alice au Pays des Merveilles (thème du hackathon)
-- - Temps de cuisson: 42 (référence geek)
-- - Difficulté: Expert (indique quelque chose de spécial)
-- - Ingrédients en binaire (anomalie évidente)
--
-- Niveau de difficulté: Intermédiaire
-- - Requiert: Injection SQL, énumération, décodage binaire
-- - Compétences: SQL, scripting (Python/Bash), encodage
-- ============================================