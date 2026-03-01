<?php

namespace Entity;

class Quote
{

    public function __construct(
        public int $id,
        public string $author,
        public string $text,
        public string $era,
        public string $theme,
        public int $year
    )
    {
    }


}