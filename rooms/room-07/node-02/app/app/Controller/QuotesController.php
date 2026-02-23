<?php

namespace Controller;

use Repository\QuoteRepository;
use Studoo\EduFramework\Core\Controller\ControllerInterface;
use Studoo\EduFramework\Core\Controller\Request;
use Studoo\EduFramework\Core\View\TwigCore;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Error\SyntaxError;

class QuotesController implements ControllerInterface
{


    public function __construct()
    {
        $this->search = null;
    }

    public function execute(Request $request): string|null
	{
        $qr = new QuoteRepository();

        if($request->getHttpMethod() === "GET" && isset($_GET["search"])){
            $this->search = $_GET["search"];
            $quotes = $qr->getQuotes(ucfirst($this->search));
        }else{
            $quotes = $qr->getQuotes();
        }

		return TwigCore::getEnvironment()->render('quotes/quotes.html.twig',
		    [
		        "titre"   => 'QuotesController',
		        "request" => $request,
                "quotes"  => $quotes
		    ]
		);
	}
}
