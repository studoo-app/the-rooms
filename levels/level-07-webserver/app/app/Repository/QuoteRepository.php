<?php

namespace Repository;

use Entity\Quote;
use PDO;
use Studoo\EduFramework\Core\Service\DatabaseService;

class QuoteRepository
{
    private PDO $bdd;

    public function __construct()
    {
        $this->bdd = DatabaseService::getConnect();
    }

    public function getQuotes(?string $search = null): array
    {

        $sql = $search ? "SELECT * FROM citations WHERE citation LIKE '%$search%' OR auteur LIKE '%$search%';" : "SELECT * FROM citations;";

        $request = $this->bdd->query($sql);

        $results = [];
        foreach ($request->fetchAll() as $value) {
            $results[] = new Quote(
                intval($value["id"]),
                $value["auteur"],
                $value["citation"],
                $value["epoque"],
                $value["theme"],
                $value["annee"],
            );
        }

        var_dump($results);

        return $results;
    }

}