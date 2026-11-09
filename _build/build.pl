#!/usr/bin/perl
# Builds every page of abschleppdienstbredemeier.de from the layout below.
# Run from the repo root: perl _build/build.pl
use strict; use warnings; use utf8;
use File::Path qw(make_path);

my $SITE  = 'https://abschleppdienstbredemeier.de';
my $NAME  = 'Abschleppdienst & Pannenhilfe Schaumburg';
my $SHORT = 'Pannenhilfe Nord';
my $TEL   = '+4917641956993';
my $TELH  = '+49 176 41956993';
my $WA    = 'https://wa.me/4917641956993?text=Hallo%2C%20ich%20brauche%20Pannenhilfe.%20Mein%20Standort%3A';
my $MAIL  = 'faster24eu@gmail.com';
my $TODAY = '2026-11-09';

my @TABS = (
  ['/', 'Start'], ['/pannenhilfe/', 'Pannenhilfe'], ['/truckservice/', 'LKW & Transporter'],
  ['/panne-a2/', 'Panne A2'], ['/regionen/', 'Regionen'], ['/adac-service/', 'ADAC & Schutzbrief'],
  ['/kontakt/', 'Kontakt'],
);

my @REGIONS = (
  ['auetal', 'Auetal'], ['rinteln', 'Rinteln'], ['bueckeburg', 'Bückeburg'],
  ['stadthagen', 'Stadthagen'], ['bad-nenndorf', 'Bad Nenndorf'], ['minden', 'Minden'],
  ['hannover', 'Hannover'], ['porta-westfalica-bad-oeynhausen', 'Porta Westfalica & Bad Oeynhausen'],
  ['hameln', 'Hameln'], ['wunstorf-barsinghausen', 'Wunstorf & Barsinghausen'],
);

sub post {
  my (%a) = @_;
  my $sub = $a{sub} // 'Pannenhilfe Nord · 24/7';
  my $src = $a{img} // ''; my $srcset = '';
  if ($src eq '/assets/cover.jpg') { $src = '/assets/cover-1200.webp'; $srcset = ' srcset="/assets/cover-800.webp 800w, /assets/cover-1200.webp 1200w" sizes="(max-width:700px) 100vw, 640px"'; }
  my $img = $a{img} ? qq{<div class="post-img"><img src="$src"$srcset alt="$a{alt}" width="1200" height="900" loading="lazy"></div>} : '';
  my $bar = ($a{bar} // 1) ? qq{<div class="post-bar"><a href="tel:$TEL">📞 Anrufen</a><a href="$WA" target="_blank" rel="noopener">💬 WhatsApp</a><a href="/kontakt/">✉️ Kontakt</a></div>} : '';
  return <<"H";
<article class="post">
<div class="post-head"><div class="post-av"><img src="/assets/logo.png" alt="Logo $SHORT" width="40" height="40"></div><div><div class="post-name">$SHORT</div><div class="post-sub">$sub</div></div></div>
<div class="post-body">
$a{html}
</div>$img$bar
</article>
H
}

sub region_chips {
  return join '', map { qq{<a href="/abschleppdienst-$_->[0]/">$_->[1]</a>} } @REGIONS;
}

sub sidebar {
  my ($extra) = @_;
  $extra //= '';
  my $chips = region_chips();
  return <<"H";
<aside class="side">
<div class="card">
<h2>Info</h2>
<ul class="info-list">
<li><span class="ico">🕒</span><span><strong>24 Stunden, 7 Tage</strong> erreichbar, auch nachts und an Feiertagen</span></li>
<li><span class="ico">📞</span><span><a href="tel:$TEL">$TELH</a></span></li>
<li><span class="ico">💬</span><span><a href="$WA" target="_blank" rel="noopener">WhatsApp mit Standort</a></span></li>
<li><span class="ico">📍</span><span>Landkreis Schaumburg, A2 zwischen Hannover und Bad Oeynhausen, Minden</span></li>
<li><span class="ico">💶</span><span>Preis am Telefon, <strong>bevor</strong> jemand losfährt</span></li>
<li><span class="ico">🤝</span><span>Wir vermitteln Abschlepp- und Pannenbetriebe aus der Region</span></li>
</ul>
</div>
$extra
<div class="card">
<h2>Einsatzgebiet</h2>
<div class="chips">$chips<a href="/panne-a2/">A2</a></div>
</div>
</aside>
H
}

sub page {
  my (%p) = @_;
  my $path  = $p{path};
  my $canon = "$SITE$path";
  my $tabs  = join '', map {
    my $on = ($p{tab} // '') eq $_->[0] ? ' class="on"' : '';
    qq{<a href="$_->[0]"$on>$_->[1]</a>}
  } @TABS;
  my $robots = $p{noindex} ? qq{<meta name="robots" content="noindex">\n} : '';
  my $ld = $p{ld} // '';
  my $side = sidebar($p{side});
  my $html = <<"H";
<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>$p{title}</title>
<meta name="description" content="$p{desc}">
${robots}<link rel="canonical" href="$canon">
<meta property="og:title" content="$p{title}"><meta property="og:description" content="$p{desc}">
<meta property="og:image" content="$SITE/assets/cover.jpg"><meta property="og:url" content="$canon"><meta property="og:type" content="website">
<meta name="theme-color" content="#1a6ee8">
<link rel="icon" href="/assets/favicon.ico"><link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon-32.png"><link rel="apple-touch-icon" href="/assets/apple-touch-icon.png">
<link rel="stylesheet" href="/styles.css">
<script>
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('consent', 'default', {'ad_storage':'denied','ad_user_data':'denied','ad_personalization':'denied','analytics_storage':'denied','wait_for_update':500});
</script>
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-18517785509"></script>
<script>
gtag('js', new Date());
gtag('config', 'AW-18517785509');
gtag('config', 'AW-18517785509/FgL9CJ2g8KQdEKX3-_1E', {'phone_conversion_number': '$TELH'});
document.addEventListener('click',function(e){var a=e.target.closest('a[href]');if(!a)return;if(/^tel:/i.test(a.getAttribute('href')))gtag('event','phone_click',{'event_category':'contact'});else if(a.href.indexOf('wa.me')!==-1)gtag('event','whatsapp_click',{'event_category':'contact'});});
</script>
$ld</head>
<body>
<header class="topbar"><div class="topbar-in">
<a class="brand" href="/"><span class="brand-dot">P</span><span>$SHORT</span></a>
<div class="top-search">🔍 Abschleppdienst Schaumburg &amp; A2</div>
<div class="top-actions"><a class="btn btn-grey" href="$WA" target="_blank" rel="noopener">WhatsApp</a><a class="btn btn-blue" href="tel:$TEL">📞 $TELH</a></div>
</div></header>
<section class="profile"><div class="profile-in">
<div class="cover"><img src="/assets/cover-1200.webp" srcset="/assets/cover-800.webp 800w, /assets/cover-1200.webp 1200w" sizes="(max-width:1100px) 100vw, 1100px" alt="Abschleppwagen mit geladenem Auto auf der Landstraße" width="1200" height="900" fetchpriority="high"></div>
<div class="head">
<div class="avatar"><img src="/assets/logo.png" alt="$SHORT" width="168" height="168"></div>
<div class="head-text"><h1>$p{h1}</h1>
<p class="head-meta">Abschleppdienst · Pannenhilfe · 24/7 · Schaumburg, A2 &amp; Hannover</p></div>
<div class="head-actions"><a class="btn btn-blue" href="tel:$TEL">📞 Jetzt anrufen</a><a class="btn btn-grey" href="$WA" target="_blank" rel="noopener">💬 WhatsApp</a></div>
</div>
<nav class="tabs" aria-label="Seiten">$tabs</nav>
</div></section>
<main class="layout">
$side
<div class="feed">
$p{feed}
</div>
</main>
<footer class="foot">
<div class="foot-links"><a href="/impressum/">Impressum</a><a href="/datenschutzerklaerung/">Datenschutz</a><a href="#" onclick="return window.openCookieBanner &amp;&amp; window.openCookieBanner(event)">Cookie-Einstellungen</a><a href="https://abschleppdienst-faster.de/">Faster Abschleppdienst (bundesweit)</a></div>
<div>© 2026 $SHORT · ein Vermittlungsdienst von Faster. Nicht verbunden mit dem ehemaligen Autohaus Bredemeier GmbH.</div>
</footer>
<div class="cookie-banner" id="cookie-banner" hidden>
<p>Wir verwenden Cookies von Google, um zu messen, ob unsere Anzeigen zu Anrufen führen. Sie können zustimmen oder ablehnen. Mehr dazu in der <a href="/datenschutzerklaerung/">Datenschutzerklärung</a>.</p>
<div class="cookie-actions"><button type="button" class="btn btn-grey" id="cookie-decline">Ablehnen</button><button type="button" class="btn btn-blue" id="cookie-accept">Akzeptieren</button></div>
</div>
<script>
(function(){
  var KEY = 'faster_cookie_consent';
  var banner = document.getElementById('cookie-banner');
  function apply(choice){
    if (choice === 'granted') gtag('consent', 'update', {'ad_storage':'granted','ad_user_data':'granted','ad_personalization':'granted','analytics_storage':'granted'});
    else if (choice === 'denied') gtag('consent', 'update', {'ad_storage':'denied','ad_user_data':'denied','ad_personalization':'denied','analytics_storage':'denied'});
  }
  function stored(){ try { return localStorage.getItem(KEY); } catch(e){ return null; } }
  function store(v){ try { localStorage.setItem(KEY, v); } catch(e){} }
  var choice = stored();
  if (choice) { apply(choice); } else if (banner) { banner.hidden = false; }
  document.getElementById('cookie-accept').addEventListener('click', function(){ store('granted'); apply('granted'); banner.hidden = true; });
  document.getElementById('cookie-decline').addEventListener('click', function(){ store('denied'); apply('denied'); banner.hidden = true; });
  window.openCookieBanner = function(e){ if (e) e.preventDefault(); banner.hidden = false; return false; };
})();
</script>
<div class="sticky-call"><a class="btn btn-blue" href="tel:$TEL">📞 Anrufen</a><a class="btn btn-wa" href="$WA">💬 WhatsApp</a></div>
</body>
</html>
H
  my $file = $path eq '/404.html' ? '404.html' : '.' . $path . 'index.html';
  if ($file =~ m{^(.*)/[^/]+$}) { make_path($1) unless -d $1 }
  open my $fh, '>:encoding(UTF-8)', $file or die "$file: $!";
  print $fh $html; close $fh;
  push our @BUILT, $path unless $p{noindex};
}

# ---------- shared blocks ----------
my $steps = post(sub => 'Angeheftet · So läuft es', html => <<'H');
<h2>Drei Schritte, dann rollt jemand</h2>
<ol>
<li><strong>Anrufen oder WhatsApp schicken.</strong> Standort reicht – eine Adresse, ein Kilometerschild an der Autobahn oder der Live-Standort aus WhatsApp.</li>
<li><strong>Preis hören.</strong> Wir nennen Ihnen den Preis am Telefon, bevor jemand losfährt. Keine Überraschung auf der Rechnung.</li>
<li><strong>Ein Betrieb aus der Nähe fährt.</strong> Wir rufen einen Abschlepp- oder Pannendienst aus Ihrer Gegend an und bleiben erreichbar, bis Ihr Auto steht, wo es hin soll.</li>
</ol>
H

my $faq_items = [
  ['Seid ihr das Autohaus Bredemeier?', 'Nein. Das Autohaus Bredemeier in Auetal-Rehren hat geschlossen. Wir sind ein unabhängiger Vermittlungsdienst für Pannenhilfe und Abschleppen und haben mit der früheren Firma nichts zu tun.'],
  ['Wie schnell ist jemand da?', 'Das hängt davon ab, wo Sie stehen, wie der Verkehr ist und welcher Betrieb gerade frei ist. Am Telefon sagen wir Ihnen eine ehrliche Schätzung, statt eine Zahl zu versprechen, die nicht hält.'],
  ['Was kostet das Abschleppen?', 'Das hängt von der Strecke, der Uhrzeit und dem Fahrzeug ab. Sie hören den Preis, bevor jemand losfährt, und entscheiden dann.'],
  ['Ich bin im ADAC – soll ich trotzdem anrufen?', 'Wenn Sie ADAC-Mitglied sind oder einen Schutzbrief haben, rufen Sie zuerst dort an, dann zahlt meistens der Club oder die Versicherung. Wenn Sie dort zu lange warten müssen oder nicht abgesichert sind, helfen wir weiter.'],
  ['Schleppt ihr auch Transporter und Wohnmobile ab?', 'Ja, wenn ein Partner mit dem passenden Fahrzeug frei ist. Sagen Sie uns Modell und ungefähres Gewicht, dann sagen wir ehrlich, ob es passt.'],
];
sub faq_html {
  my $out = qq{<h2>Häufige Fragen</h2><div class="faq">};
  $out .= qq{<details><summary>$_->[0]</summary><p>$_->[1]</p></details>} for @$faq_items;
  return "$out</div>";
}
sub faq_ld {
  my $items = join ',', map {
    (my $q = $_->[0]) =~ s/"/\\"/g; (my $a = $_->[1]) =~ s/"/\\"/g;
    qq{{"\@type":"Question","name":"$q","acceptedAnswer":{"\@type":"Answer","text":"$a"}}}
  } @$faq_items;
  return qq{<script type="application/ld+json">{"\@context":"https://schema.org","\@type":"FAQPage","mainEntity":[$items]}</script>\n};
}
my $org_ld = qq{<script type="application/ld+json">{"\@context":"https://schema.org","\@type":"AutomotiveBusiness","\@id":"$SITE/#business","name":"$SHORT","url":"$SITE/","telephone":"$TELH","email":"$MAIL","image":"$SITE/assets/cover.jpg","openingHours":"Mo-Su 00:00-23:59","areaServed":[{"\@type":"AdministrativeArea","name":"Landkreis Schaumburg"},{"\@type":"City","name":"Hannover"},{"\@type":"City","name":"Minden"}]}</script>\n};

my $notice = <<'H';
<div class="card notice">
<h2>Hinweis</h2>
<p>Das <strong>Autohaus Bredemeier</strong> in Auetal-Rehren hat geschlossen. Diese Seite gehört nicht zur früheren Firma.</p>
<p style="margin:0">Wir sind ein unabhängiger Vermittlungsdienst und organisieren rund um die Uhr Pannenhilfe und Abschleppen in Schaumburg und an der A2.</p>
</div>
H

# ---------- home ----------
page(
  path => '/', tab => '/',
  title => 'Abschleppdienst & Pannenhilfe Schaumburg 24/7 | A2, Rinteln, Hannover',
  desc  => "Panne in Schaumburg oder auf der A2? Rund um die Uhr Abschleppdienst und Pannenhilfe, Preis vor der Fahrt. Jetzt anrufen: $TELH",
  h1    => $NAME, side => $notice, ld => $org_ld . faq_ld(),
  feed  => $steps
    . post(sub => 'Pannenhilfe Nord · 24/7', img => '/assets/cover.jpg', alt => 'Abschleppwagen mit Auto auf dem Plateau', html => <<'H')
<h2>Liegengeblieben in Schaumburg oder auf der A2?</h2>
<p>Batterie leer, Reifen platt, Motor aus oder ein Unfall: Wir organisieren einen Abschleppwagen oder Pannenhilfe aus der Region – in Auetal, Rinteln, Bückeburg, Stadthagen, Bad Nenndorf, Minden und Hannover, und auf der A2 dazwischen.</p>
<p>Sie rufen eine Nummer an, wir telefonieren für Sie herum. Den Preis hören Sie, bevor jemand losfährt.</p>
H
    . post(sub => 'Leistungen', html => <<'H')
<h2>Wobei wir helfen</h2>
<ul>
<li><a href="/pannenhilfe/"><strong>Pannenhilfe vor Ort</strong></a> – Starthilfe, Radwechsel, leerer Tank. Wenn es vor Ort geht, muss das Auto nicht auf den Wagen.</li>
<li><strong>Abschleppen</strong> – in die Werkstatt Ihrer Wahl, nach Hause oder auf einen sicheren Stellplatz.</li>
<li><strong>Unfall und Bergung</strong> – wenn das Auto nicht mehr fährt oder von der Fahrbahn muss.</li>
<li><a href="/truckservice/"><strong>Transporter, Wohnmobil, LKW</strong></a> – wir sagen ehrlich, ob ein Partner das passende Fahrzeug hat.</li>
<li><a href="/panne-a2/"><strong>Panne auf der A2</strong></a> – was Sie sofort tun sollten und wer Sie dort abholen darf.</li>
</ul>
H
    . post(sub => 'Fragen und Antworten', html => faq_html()),
);

# ---------- Pannenhilfe ----------
page(
  path => '/pannenhilfe/', tab => '/pannenhilfe/',
  title => 'Pannenhilfe Schaumburg & A2 – rund um die Uhr | Pannenhilfe Nord',
  desc  => "Starthilfe, Radwechsel, leerer Tank oder Motor aus: Pannenhilfe in Schaumburg, Hannover und auf der A2. Preis vor der Fahrt. $TELH",
  h1 => 'Pannenhilfe Schaumburg & A2',
  feed => post(sub => 'Pannenhilfe', html => <<'H')
<h2>Pannenhilfe: oft geht es ohne Abschleppen</h2>
<p>Nicht jede Panne endet auf dem Abschleppwagen. Viele Autos fahren nach ein paar Minuten weiter. Sagen Sie uns am Telefon, was passiert ist – dann schicken wir die passende Hilfe und nicht automatisch den großen Wagen.</p>
<h3>Was vor Ort oft klappt</h3>
<ul>
<li><strong>Batterie leer:</strong> Starthilfe. Springt der Motor danach an, lassen Sie ihn eine Weile laufen, bevor Sie ihn wieder abstellen.</li>
<li><strong>Reifen platt:</strong> Radwechsel, wenn ein Ersatzrad oder Notrad an Bord ist. Ohne Ersatzrad hilft meistens nur Abschleppen.</li>
<li><strong>Tank leer:</strong> Ein paar Liter Kraftstoff bis zur nächsten Tankstelle.</li>
<li><strong>Auto verschlossen, Schlüssel drin:</strong> Sagen Sie uns das Modell; nicht jedes Auto lässt sich ohne Schaden öffnen.</li>
</ul>
<h3>Wann das Auto auf den Wagen muss</h3>
<p>Wenn Warnleuchten für Öldruck oder Motortemperatur leuchten, wenn Flüssigkeit ausläuft oder nach einem Unfall: nicht weiterfahren. Dann bringen wir das Auto in eine Werkstatt Ihrer Wahl oder zu Ihnen nach Hause.</p>
<h3>Was wir am Telefon wissen müssen</h3>
<ol>
<li>Wo stehen Sie? (Adresse, Straße oder Kilometerschild)</li>
<li>Welches Auto? (Marke, Modell, Automatik oder Schaltung, E-Auto?)</li>
<li>Was ist passiert? (geht nicht an, Geräusch, Warnleuchte, Unfall)</li>
<li>Wohin soll es, falls abgeschleppt werden muss?</li>
</ol>
H
);

# ---------- Truckservice ----------
page(
  path => '/truckservice/', tab => '/truckservice/',
  title => 'Transporter, Wohnmobil & LKW abschleppen – Schaumburg & A2',
  desc  => "Transporter, Wohnmobil oder LKW liegengeblieben? Wir vermitteln Betriebe mit passendem Fahrzeug in Schaumburg, Hannover und an der A2. $TELH",
  h1 => 'Transporter, Wohnmobil & LKW',
  feed => post(sub => 'Schwere Fahrzeuge', html => <<'H')
<h2>Transporter, Wohnmobil und LKW</h2>
<p>Auf der A2 ist viel Lieferverkehr unterwegs. Bleibt ein Sprinter, ein Wohnmobil oder ein LKW liegen, braucht es ein anderes Fahrzeug als für einen Kleinwagen. Wir sagen Ihnen ehrlich, ob ein Partner aus der Region das passende Gerät frei hat – statt jemanden zu schicken, der dann vor Ort umdrehen muss.</p>
<h3>Bis 3,5 Tonnen</h3>
<p>Transporter, Kastenwagen und die meisten Wohnmobile passen auf einen großen Abschleppwagen mit Plateau. Wichtig ist das tatsächliche Gewicht mit Ladung, nicht nur das Leergewicht.</p>
<h3>Über 3,5 Tonnen</h3>
<p>Für schwere Wohnmobile, 7,5-Tonner und LKW braucht es ein Bergefahrzeug. Das gibt es nicht an jeder Ecke; die Anfahrt kann länger dauern. Wir sagen Ihnen das am Telefon, bevor Sie warten.</p>
<h3>Für Speditionen und Flotten</h3>
<ul>
<li>Kennzeichen, Fahrzeugtyp und zulässiges Gesamtgewicht</li>
<li>Ladung (Art, ungefähres Gewicht, Gefahrgut ja oder nein)</li>
<li>Standort und Fahrtrichtung</li>
<li>Wohin das Fahrzeug soll und wer die Rechnung bekommt</li>
</ul>
H
);

# ---------- A2 ----------
page(
  path => '/panne-a2/', tab => '/panne-a2/',
  title => 'Panne auf der A2 bei Hannover, Schaumburg & Minden – was tun?',
  desc  => 'Panne auf der A2? Was Sie sofort tun müssen, wer Sie abschleppen darf und wie Sie schnell Hilfe bekommen. Rund um die Uhr erreichbar.',
  h1 => 'Panne auf der A2',
  feed => post(sub => 'A2 · Hannover – Schaumburg – Minden', html => <<'H')
<h2>Panne auf der A2: erst sichern, dann telefonieren</h2>
<p>Die A2 zwischen Hannover, Bad Nenndorf, Auetal und Bad Oeynhausen gehört zu den vollsten Autobahnen Deutschlands, mit sehr vielen LKW. Bei einer Panne geht Sicherheit vor allem anderen.</p>
<h3>Sofort</h3>
<ol>
<li><strong>Warnblinker an</strong> und so weit wie möglich nach rechts, am besten auf den Standstreifen oder in eine Nothaltebucht.</li>
<li><strong>Warnweste anziehen</strong>, bevor Sie aussteigen. Auf der Beifahrerseite aussteigen.</li>
<li><strong>Alle hinter die Leitplanke.</strong> Nicht im Auto sitzen bleiben und nicht zwischen Auto und Leitplanke stehen.</li>
<li><strong>Warndreieck aufstellen</strong>, auf der Autobahn mit großem Abstand zum Auto. Am Rand gehen, nicht auf der Fahrbahn.</li>
<li>Bei Verletzten, Rauch oder wenn das Auto auf einer Fahrspur steht: <strong>112</strong>.</li>
</ol>
<h3>Wer Sie auf der Autobahn abschleppt</h3>
<p>Steht das Auto gefährlich oder blockiert eine Spur, kann die Polizei einen Abschleppdienst bestimmen. Steht es sicher auf dem Standstreifen, dürfen Sie selbst entscheiden, wen Sie anrufen – den ADAC, Ihren Schutzbrief oder uns.</p>
<p>Selbst abschleppen mit Seil oder Stange ist auf der Autobahn nur bis zur nächsten Ausfahrt erlaubt. Ehrlich gesagt: Bei dem Verkehr auf der A2 raten wir davon ab.</p>
<h3>Ihren Standort finden</h3>
<p>Haben Sie es noch bis zur Raststätte geschafft? Dann lesen Sie <a href="/a2-rasthof-garbsen-lauenau/">Panne an der Raststätte Garbsen oder bei Lauenau</a>.</p>
<p>Am rechten Fahrbahnrand stehen alle paar hundert Meter kleine Kilometerschilder. Sagen Sie uns die Zahl, die Fahrtrichtung (zum Beispiel „Richtung Dortmund“ oder „Richtung Berlin“) und die letzte Ausfahrt, an der Sie vorbeigekommen sind. Noch einfacher: Live-Standort per WhatsApp.</p>
H
);

# ---------- ADAC & Schutzbrief ----------
page(
  path => '/adac-service/', tab => '/adac-service/',
  title => 'ADAC, Schutzbrief oder privater Abschleppdienst? | Pannenhilfe Nord',
  desc  => 'ADAC-Mitglied oder Schutzbrief über die Kfz-Versicherung? So entscheiden Sie bei einer Panne, wen Sie anrufen – und wann ein privater Abschleppdienst sinnvoll ist.',
  h1 => 'ADAC, Schutzbrief oder privat?',
  feed => post(sub => 'Ratgeber', html => <<'H')
<h2>Wen rufe ich bei einer Panne zuerst an?</h2>
<p>Wir sind <strong>kein</strong> ADAC-Partner und arbeiten nicht im Auftrag eines Automobilclubs. Diese Seite soll Ihnen helfen, das Richtige zu tun – auch wenn das heißt, dass Sie nicht uns anrufen.</p>
<h3>Sie sind ADAC-Mitglied</h3>
<p>Rufen Sie zuerst die ADAC-Pannenhilfe an (Telefon 089 20 20 4000 oder über die ADAC-App). Pannenhilfe vor Ort ist bei der Mitgliedschaft dabei. Wie weit abgeschleppt wird, hängt von Ihrem Tarif ab – fragen Sie am Telefon nach.</p>
<h3>Sie haben einen Schutzbrief</h3>
<p>Viele Kfz-Versicherungen bieten einen Schutzbrief an. Die Nummer steht meist auf der Versicherungskarte oder in der App. Auch hier gilt: zuerst dort anrufen, sonst zahlt die Versicherung am Ende vielleicht nicht.</p>
<h3>Wann ein privater Abschleppdienst sinnvoll ist</h3>
<ul>
<li>Sie sind weder im Automobilclub noch haben Sie einen Schutzbrief.</li>
<li>Die Wartezeit ist Ihnen zu lang, und Sie zahlen lieber selbst.</li>
<li>Das Fahrzeug ist nicht versichert, zum Beispiel ein Transporter oder ein Wohnmobil außerhalb des Tarifs.</li>
</ul>
<p>Wenn Sie uns anrufen, nennen wir den Preis vorher. Fragen Sie Ihren Club oder Ihre Versicherung, ob sie einen Teil davon erstattet – manchmal geht das, oft nicht.</p>
H
);

# ---------- Regions ----------
my %R = (
  'porta-westfalica-bad-oeynhausen' => {
    title => 'Abschleppdienst Porta Westfalica & Bad Oeynhausen 24/7',
    desc  => "Panne in Porta Westfalica, Bad Oeynhausen oder am Kreuz A2/A30? Abschleppdienst rund um die Uhr, Preis vor der Fahrt. $TELH",
    cities => ['Porta Westfalica', 'Bad Oeynhausen'],
    html  => <<'H',
<h2>Abschleppdienst in Porta Westfalica und Bad Oeynhausen</h2>
<p>Bei Porta Westfalica bricht die Weser durch das Weser- und Wiehengebirge. Oben auf dem Wittekindsberg steht das Kaiser-Wilhelm-Denkmal, unten teilen sich Fluss, Bahn, Bundesstraßen und die A2 den engen Durchgang. Für Autofahrer heißt das: viel Verkehr auf wenig Platz, und nach einer Panne gibt es oft keine Ausweichmöglichkeit. Wir vermitteln rund um die Uhr Pannenhilfe und Abschleppen in Porta Westfalica, in Bad Oeynhausen und auf der Autobahn dazwischen.</p>
<h3>A2, A30 und das Kreuz Bad Oeynhausen</h3>
<p>Die A2 verläuft südlich von Minden durch Porta Westfalica und weiter nach Bad Oeynhausen. Am Kreuz Bad Oeynhausen zweigt die A30 Richtung Osnabrück ab. Seit die Nordumgehung fertig ist, rollt der Fernverkehr nicht mehr mitten durch die Kurstadt, dafür sind Kreuz und Rampen jetzt die Stellen, an denen es eng wird. Auf den Verbindungsrampen gibt es kaum Platz zum Halten.</p>
<p>Bleiben Sie dort liegen: Warnblinker an, Warnweste an, alle Insassen hinter die Leitplanke, erst dann anrufen. Sagen Sie uns, ob Sie auf der A2 oder der A30 stehen, in welche Richtung Sie fahren, zum Beispiel „A2 Richtung Hannover“ oder „A30 Richtung Osnabrück“, und welche Anschlussstelle zuletzt kam. Die kleinen Kilometerschilder am Fahrbahnrand helfen dem Fahrer, Sie auf Anhieb zu finden. Noch einfacher ist der Live-Standort per WhatsApp.</p>
<h3>Bundesstraßen und Ortsteile</h3>
<p>Abseits der Autobahn haben wir die meisten Einsätze auf der B 61 zwischen Minden und Bad Oeynhausen und auf der B 482, die an der Anschlussstelle Porta Westfalica beginnt und an der Weser entlang nach Norden führt. Wer auf der Bundesstraße liegen bleibt, stellt das Warndreieck außerorts mit etwa 100 Metern Abstand auf und wartet hinter der Leitplanke oder abseits der Fahrbahn.</p>
<p>In Porta Westfalica helfen wir in allen Ortsteilen, von Barkhausen und Hausberge über Lerbeck, Neesen und Holzhausen bis Eisbergen, Veltheim und Möllbergen. In Bad Oeynhausen kommen wir genauso nach Rehme an der Weser, nach Eidinghausen, Dehme, Werste, Lohe oder Volmerdingsen.</p>
<h3>Typische Einsätze</h3>
<ul>
<li>Panne im Berufsverkehr auf der A2 zwischen Porta Westfalica und Bad Oeynhausen, oft mit vielen LKW auf der rechten Spur</li>
<li>Auto springt nach einem Termin nicht an, etwa auf einem Parkplatz am Kurpark oder am Herz- und Diabeteszentrum in Bad Oeynhausen</li>
<li>Reifenpanne auf der B 61 oder auf dem Weg über die Weser</li>
<li>Abschleppen zur eigenen Werkstatt in Minden, Bad Oeynhausen oder zurück nach Schaumburg</li>
</ul>
<h3>Über die Landesgrenze</h3>
<p>Porta Westfalica und Bad Oeynhausen gehören zu Nordrhein-Westfalen und zum Kreis Minden-Lübbecke. Unser Schwerpunkt liegt gleich nebenan in Schaumburg in Niedersachsen. Für Sie spielt die Grenze keine Rolle: Wir rufen den Betrieb an, der am schnellsten bei Ihnen sein kann, egal auf welcher Seite. Den Preis hören Sie vorher am Telefon, auch wenn das Auto über die Grenze in eine Werkstatt nach <a href="/abschleppdienst-bueckeburg/">Bückeburg</a> oder <a href="/abschleppdienst-rinteln/">Rinteln</a> soll. Nach Norden schließt <a href="/abschleppdienst-minden/">Minden</a> direkt an.</p>
<h3>Was Sie bereithalten sollten</h3>
<p>Ihren Standort, Modell und Kennzeichen, was passiert ist, zum Beispiel ein Geräusch, eine Warnleuchte, Rauch oder ein Unfall, und wohin das Auto soll. Sind Sie im ADAC oder haben Sie einen Schutzbrief, rufen Sie zuerst dort an, dann zahlt meistens der Club oder die Versicherung. Sind Sie nicht abgesichert oder dauert es Ihnen dort zu lange, helfen wir weiter.</p>
H
    faq => [
      ['Helfen Sie auch am Kreuz Bad Oeynhausen?', 'Ja. Sagen Sie uns, ob Sie auf der A2 oder der A30 stehen, die Fahrtrichtung und die letzte Anschlussstelle. Gehen Sie zuerst hinter die Leitplanke.'],
      ['Kostet es mehr, weil Porta Westfalica in NRW liegt?', 'Nein, die Landesgrenze ändert nichts. Der Preis hängt von Strecke, Uhrzeit und Fahrzeug ab und wird vor der Fahrt genannt.'],
      ['Können Sie mein Auto nach Schaumburg bringen?', 'Ja, zum Beispiel in eine Werkstatt in Bückeburg, Rinteln oder Stadthagen oder zu Ihnen nach Hause.'],
    ],
  },
  'hameln' => {
    title => 'Abschleppdienst Hameln 24/7 – Pannenhilfe an der Weser',
    desc  => "Panne in Hameln, auf der B 83, B 1 oder B 217? Abschleppdienst und Pannenhilfe rund um die Uhr, Preis vor der Fahrt. $TELH",
    html  => <<'H',
<h2>Abschleppdienst in Hameln</h2>
<p>Hameln ist die Kreisstadt des Landkreises Hameln-Pyrmont und liegt an der Weser, etwa eine halbe Stunde weseraufwärts von Rinteln. Eine Autobahn gibt es hier nicht. Der Verkehr läuft über Bundesstraßen: die B 83 an der Weser entlang Richtung Rinteln und Höxter, die B 1 Richtung Hildesheim und die B 217 über Springe nach Hannover. Auf diesen Straßen, in der Altstadt und in den Ortsteilen vermitteln wir rund um die Uhr Pannenhilfe und Abschleppen.</p>
<h3>Landstraße statt Autobahn: so sichern Sie sich</h3>
<p>Auf B 83, B 1 und B 217 gibt es meist keinen Standstreifen. Rollen Sie, wenn es noch geht, auf einen Parkplatz, in eine Einfahrt oder auf einen Feldweg. Warnblinker an, Warnweste an und das Warndreieck außerorts mit etwa 100 Metern Abstand aufstellen, in Kurven eher mehr. Warten Sie hinter der Leitplanke oder neben der Straße, nicht im Auto. Nachts und bei Nebel im Wesertal ist das besonders wichtig.</p>
<h3>In der Altstadt</h3>
<p>Rund um die Osterstraße und den Pferdemarkt ist die Hamelner Altstadt zu großen Teilen Fußgängerzone, dazu kommen enge Gassen und Parkhäuser mit niedriger Einfahrt. Steht Ihr Auto dort, sagen Sie uns bitte genau, wo: Parkhaus, Etage und Einfahrtshöhe, wenn Sie sie sehen. Dann schickt der Partner einen Wagen, der wirklich hineinpasst, und nicht den großen Abschleppwagen, der vor der Schranke stehen bleibt.</p>
<h3>Ortsteile und Nachbarorte</h3>
<p>Wir helfen in allen Ortsteilen, zum Beispiel in Afferde, Klein Berkel, Rohrsen, Tündern, Hastenbeck oder Halvestorf, und in den Nachbargemeinden Emmerthal, Aerzen und Hessisch Oldendorf. Im Weserbergland sind die Wege zwischen den Dörfern oft länger als gedacht. Am Telefon sagen wir Ihnen ehrlich, wie lange es ungefähr dauert, statt eine Zahl zu versprechen, die nicht hält.</p>
<h3>Typische Einsätze in Hameln</h3>
<ul>
<li>Batterie leer nach einer kalten Nacht: Starthilfe vor der Haustür oder auf dem Firmenparkplatz</li>
<li>Panne auf der B 83 zwischen Hameln und Hessisch Oldendorf oder auf dem Weg nach Rinteln</li>
<li>Motorrad liegengeblieben auf einer Tour durchs Weserbergland: Transport auf dem Plateau, nicht am Seil</li>
<li>Abschleppen aus einem Parkhaus in der Innenstadt</li>
<li>Auto nach einem kleinen Unfall nicht mehr fahrbereit: Transport zur Werkstatt Ihrer Wahl</li>
</ul>
<h3>Wohin mit dem Auto?</h3>
<p>Meist bringt der Partner Ihr Auto in eine Werkstatt in Hameln. Möchten Sie lieber in Ihre eigene Werkstatt, etwa nach <a href="/abschleppdienst-rinteln/">Rinteln</a> oder <a href="/abschleppdienst-stadthagen/">Stadthagen</a>, ist das genauso möglich. Den Preis für die Strecke nennen wir vorher. Nachts kann das Auto zuerst zu Ihnen nach Hause und am nächsten Werktag weiter.</p>
<p>Wenn Sie ADAC-Mitglied sind oder einen Schutzbrief haben, rufen Sie zuerst dort an. Sonst rufen Sie uns an oder schicken eine WhatsApp mit Ihrem Standort.</p>
H
    faq => [
      ['Wie schnell ist jemand in Hameln?', 'Das hängt davon ab, wo genau Sie stehen und welcher Betrieb frei ist. Am Telefon bekommen Sie eine ehrliche Schätzung.'],
      ['Mein Auto steht in einem Parkhaus in der Altstadt. Geht das?', 'Oft ja. Sagen Sie uns Parkhaus, Etage und Einfahrtshöhe, dann kommt ein passendes, niedriges Fahrzeug.'],
      ['Transportieren Sie auch Motorräder?', 'Ja, auf dem Plateau und gesichert. Sagen Sie uns Modell und ob das Motorrad noch rollt.'],
    ],
  },
  'wunstorf-barsinghausen' => {
    title => 'Abschleppdienst Wunstorf & Barsinghausen 24/7',
    desc  => "Panne in Wunstorf, Steinhude, Barsinghausen oder an der A2 bei Kolenfeld und Luthe? Abschleppdienst rund um die Uhr. $TELH",
    cities => ['Wunstorf', 'Barsinghausen'],
    html  => <<'H',
<h2>Abschleppdienst in Wunstorf und Barsinghausen</h2>
<p>Wunstorf und Barsinghausen liegen westlich von Hannover, zwischen dem Steinhuder Meer im Norden und dem Deister im Süden. Dazwischen verläuft die A2 mit den Anschlussstellen Wunstorf-Kolenfeld und Wunstorf-Luthe. Wir vermitteln rund um die Uhr Pannenhilfe und Abschleppen in beiden Städten, in den Dörfern drumherum und auf der Autobahn.</p>
<h3>Auf der A2 zwischen Bad Nenndorf und Garbsen</h3>
<p>Auf diesem Abschnitt ist sehr viel LKW-Verkehr unterwegs. Bei einer Panne: Warnblinker an, auf den Standstreifen, Warnweste anziehen und auf der Beifahrerseite aussteigen. Alle Insassen hinter die Leitplanke, dann das Warndreieck mit großem Abstand aufstellen. Erst danach anrufen. Sagen Sie uns die Fahrtrichtung, zum Beispiel „Richtung Hannover“ oder „Richtung Dortmund“, und ob Kolenfeld oder Luthe die letzte Ausfahrt war. Mehr dazu auf unserer Seite <a href="/panne-a2/">Panne auf der A2</a>. Haben Sie es noch bis zur Raststätte geschafft, lesen Sie <a href="/a2-rasthof-garbsen-lauenau/">Panne an der Raststätte Garbsen oder bei Lauenau</a>.</p>
<h3>Wunstorf und Steinhude</h3>
<p>In Wunstorf helfen wir in der Kernstadt und in allen Ortsteilen, darunter Luthe, Kolenfeld, Idensen, Bokeloh, Klein Heidorn und Großenheidorn. Im Sommer ist in Steinhude am Steinhuder Meer viel los: volle Parkplätze an der Promenade, Ausflügler mit Wohnmobil und Wohnwagen. Bleibt dort ein Gespann liegen, sagen Sie uns Länge und ungefähres Gewicht, damit ein Betrieb mit passendem Fahrzeug kommt. In die Stadt führt außerdem die B 441 aus Richtung Hannover.</p>
<h3>Barsinghausen am Deister</h3>
<p>Barsinghausen liegt am Nordhang des Deisters. Die Straßen hinauf in den Wald sind kurvig und steil und im Winter schnell glatt. Wer dort mit leerer Batterie oder festgefahren am Waldparkplatz steht, braucht oft nur Starthilfe oder ein kurzes Herausziehen. Wir helfen auch in den Ortsteilen, zum Beispiel in Egestorf, Kirchdorf, Bantorf, Groß Munzel, Hohenbostel, Langreder oder Stemmen.</p>
<h3>Typische Einsätze</h3>
<ul>
<li>Panne auf der A2 zwischen den Anschlussstellen Wunstorf-Kolenfeld und Wunstorf-Luthe</li>
<li>Wohnmobil oder Wohnwagen am Steinhuder Meer liegengeblieben</li>
<li>Auto springt am Bahnhofsparkplatz in Wunstorf oder Barsinghausen nach dem Feierabend nicht an</li>
<li>Glätte am Deister: Auto steckt fest oder ist in den Graben gerutscht</li>
<li>Abschleppen in eine Werkstatt in Wunstorf, Barsinghausen, Garbsen oder Hannover</li>
</ul>
<h3>Preis und Ablauf</h3>
<p>Sie rufen an oder schicken eine WhatsApp mit Live-Standort. Wir fragen nach Fahrzeug, Problem und Ziel und nennen Ihnen den Preis, bevor jemand losfährt. Dann rufen wir einen Betrieb aus der Nähe an, zum Beispiel aus Wunstorf, <a href="/abschleppdienst-bad-nenndorf/">Bad Nenndorf</a> oder <a href="/abschleppdienst-hannover/">Hannover</a>, und bleiben erreichbar, bis Ihr Auto steht, wo es hin soll. Sind Sie im ADAC oder haben Sie einen Schutzbrief, rufen Sie zuerst dort an.</p>
H
    faq => [
      ['Helfen Sie auch am Steinhuder Meer?', 'Ja, in Steinhude, Großenheidorn und rund um den See. Bei Wohnmobil oder Gespann bitte Länge und Gewicht nennen.'],
      ['Ich stehe auf der A2 bei Kolenfeld. Was sage ich am Telefon?', 'Fahrtrichtung, die letzte Ausfahrt und die Zahl auf dem nächsten Kilometerschild. Vorher hinter die Leitplanke gehen.'],
      ['Ziehen Sie auch Autos am Deister heraus?', 'Ja, wenn ein Partner mit passendem Fahrzeug frei ist. Ein Foto per WhatsApp hilft, die Lage einzuschätzen.'],
    ],
  },
  'auetal' => {
    title => 'Abschleppdienst Auetal & Rehren 24/7 – auch auf der A2',
    desc  => "Panne in Auetal, Rehren oder auf der A2? Abschleppdienst und Pannenhilfe rund um die Uhr, Preis vor der Fahrt. $TELH",
    html  => <<'H'},
<h2>Abschleppdienst in Auetal</h2>
<p>Auetal liegt mitten im Landkreis Schaumburg und direkt an der A2. Viele unserer Anrufe aus der Gegend kommen von der Autobahn: Pendler zwischen Hannover und Bielefeld, Urlauber, LKW-Fahrer. Dazu kommen die Ortsteile abseits der großen Straßen, wo nach einer Panne nachts kaum jemand vorbeikommt.</p>
<p>Seit das Autohaus Bredemeier in Rehren geschlossen hat, fehlt im Ort ein Betrieb mit eigenem Abschleppwagen. Wir rufen für Sie einen Partner aus der Umgebung an und sagen Ihnen vorher, was es kostet.</p>
<h3>Typische Einsätze</h3>
<ul>
<li>Panne auf der A2 in beide Richtungen – lesen Sie auch <a href="/panne-a2/">was bei einer Panne auf der A2 zu tun ist</a></li>
<li>Auto springt morgens nicht an – Starthilfe vor der Haustür</li>
<li>Abschleppen in eine Werkstatt in Rinteln, Stadthagen oder Bad Nenndorf</li>
</ul>
H
  'rinteln' => {
    title => 'Abschleppdienst Rinteln 24/7 – Pannenhilfe an der Weser',
    desc  => "Abschleppdienst und Pannenhilfe in Rinteln und Umgebung, rund um die Uhr. Preis am Telefon, bevor jemand losfährt. $TELH",
    html  => <<'H'},
<h2>Abschleppdienst in Rinteln</h2>
<p>Rinteln liegt an der Weser, mit der B 83 Richtung Bückeburg und Hameln und kurzen Wegen zur A2. Wir organisieren Pannenhilfe und Abschleppen in der Stadt und in den Dörfern rundherum.</p>
<h3>Worauf es in Rinteln ankommt</h3>
<ul>
<li><strong>Altstadt und enge Straßen:</strong> Sagen Sie uns, wenn das Auto in einer engen Gasse oder einem Hinterhof steht. Dann schickt der Partner einen passenden Wagen.</li>
<li><strong>Landstraße an der Weser:</strong> Stehen Sie außerorts, Warnblinker an und Warndreieck mit Abstand aufstellen.</li>
<li><strong>Werkstatt am nächsten Morgen:</strong> Nachts bringen wir das Auto auf Wunsch zu Ihnen nach Hause und am nächsten Tag weiter.</li>
</ul>
H
  'bueckeburg' => {
    title => 'Abschleppdienst Bückeburg 24/7 – Pannenhilfe B 65 & B 83',
    desc  => "Panne in Bückeburg? Abschleppdienst und Pannenhilfe rund um die Uhr, vermittelt von einem Partner aus der Region. $TELH",
    html  => <<'H'},
<h2>Abschleppdienst in Bückeburg</h2>
<p>Zwischen Minden und Stadthagen, an B 65 und B 83, ist in Bückeburg viel Durchgangsverkehr unterwegs. Wir vermitteln Pannenhilfe und Abschleppen in der Stadt, in den Ortsteilen und auf den Bundesstraßen.</p>
<h3>Schnell erklärt, schnell geholfen</h3>
<p>Nennen Sie uns die Straße und eine Hausnummer oder einen Orientierungspunkt. Auf der Bundesstraße hilft die Fahrtrichtung, zum Beispiel „B 65 Richtung Minden“. Den Preis sagen wir Ihnen am Telefon.</p>
<p>Muss das Auto in die Werkstatt, bringt der Partner es zu einer Werkstatt Ihrer Wahl – in Bückeburg, Minden oder wohin Sie möchten.</p>
H
  'stadthagen' => {
    title => 'Abschleppdienst Stadthagen 24/7 – Pannenhilfe im Kreis Schaumburg',
    desc  => "Abschleppdienst und Pannenhilfe in Stadthagen und Umgebung, rund um die Uhr erreichbar, Preis vor der Fahrt. $TELH",
    html  => <<'H'},
<h2>Abschleppdienst in Stadthagen</h2>
<p>Stadthagen ist die Kreisstadt von Schaumburg. Von hier sind es nur wenige Kilometer zur A2 und zur B 65. Wir organisieren Hilfe in der Stadt, in den umliegenden Dörfern und auf dem Weg zur Autobahn.</p>
<h3>Häufige Anrufe aus Stadthagen</h3>
<ul>
<li>Batterie leer nach einer kalten Nacht – Starthilfe vor Ort</li>
<li>Auto nach einem kleinen Unfall nicht mehr fahrbereit</li>
<li>Abschleppen vom Supermarkt-Parkplatz oder aus dem Parkhaus</li>
</ul>
<p>Steht Ihr Auto in einem Parkhaus mit niedriger Einfahrt, sagen Sie es uns. Nicht jeder Abschleppwagen kommt hinein.</p>
H
  'bad-nenndorf' => {
    title => 'Abschleppdienst Bad Nenndorf 24/7 – Pannenhilfe an der A2',
    desc  => "Panne in Bad Nenndorf oder an der A2-Ausfahrt? Abschleppdienst und Pannenhilfe rund um die Uhr. $TELH",
    html  => <<'H'},
<h2>Abschleppdienst in Bad Nenndorf</h2>
<p>Bad Nenndorf liegt an der A2 und an der B 65, auf halbem Weg zwischen Hannover und Stadthagen. Viele unserer Einsätze hier beginnen auf der Autobahn oder kurz nach der Ausfahrt.</p>
<p>Bleiben Sie auf der Autobahn liegen, gilt zuerst: sichern, hinter die Leitplanke, dann anrufen. Die wichtigsten Schritte stehen auf unserer Seite <a href="/panne-a2/">Panne auf der A2</a>.</p>
<h3>In der Stadt</h3>
<p>Im Ort helfen wir genauso: Starthilfe vor dem Hotel, Abschleppen vom Kurpark-Parkplatz, Transport zur Werkstatt. Der Preis steht fest, bevor jemand losfährt.</p>
H
  'minden' => {
    title => 'Abschleppdienst Minden 24/7 – Pannenhilfe bis Porta Westfalica',
    desc  => "Abschleppdienst und Pannenhilfe in Minden, Porta Westfalica und an der A2 – rund um die Uhr, Preis vor der Fahrt. $TELH",
    html  => <<'H'},
<h2>Abschleppdienst in Minden</h2>
<p>Minden liegt schon in Nordrhein-Westfalen, aber nur wenige Kilometer von Bückeburg entfernt. Die A2 verläuft südlich der Stadt bei Porta Westfalica, dazu kommen B 61 und B 65. Wir vermitteln Pannenhilfe und Abschleppen in Minden und Umgebung.</p>
<h3>Gut zu wissen</h3>
<ul>
<li>Für Fahrten über die Landesgrenze nach Niedersachsen gilt derselbe Preis, den wir Ihnen vorher nennen.</li>
<li>Auf der A2 bei Porta Westfalica herrscht oft dichter LKW-Verkehr. Bleiben Sie hinter der Leitplanke, bis der Abschleppwagen da ist.</li>
<li>Sie möchten das Auto nach Hause bringen lassen, nicht in eine Werkstatt? Sagen Sie es einfach.</li>
</ul>
H
  'hannover' => {
    title => 'Abschleppdienst Hannover 24/7 – Pannenhilfe auf A2 & A7',
    desc  => "Panne in Hannover oder am Kreuz Hannover-Ost? Abschleppdienst und Pannenhilfe rund um die Uhr, Preis vor der Fahrt. $TELH",
    html  => <<'H',
<h2>Abschleppdienst in Hannover</h2>
<p>In und um Hannover kreuzen sich A2 und A7, dazu kommen der Messeschnellweg und viel Stadtverkehr. Wir vermitteln Pannenhilfe und Abschleppen in Hannover und auf dem Weg nach Westen Richtung Schaumburg.</p>
<h3>In der Stadt</h3>
<ul>
<li><strong>Tiefgarage oder Parkhaus:</strong> Sagen Sie uns die Einfahrtshöhe, wenn Sie sie sehen. Für niedrige Garagen gibt es spezielle Fahrzeuge.</li>
<li><strong>Anwohnerstraße, zugeparkt:</strong> Ein Foto per WhatsApp hilft dem Fahrer, den richtigen Wagen mitzubringen.</li>
<li><strong>E-Auto:</strong> Elektroautos werden auf dem Plateau transportiert, nicht geschleppt. Sagen Sie uns das Modell.</li>
</ul>
<p>Stehen Sie auf der Autobahn, lesen Sie zuerst unsere Hinweise zur <a href="/panne-a2/">Panne auf der A2</a>.</p>
<h3>Auf der Autobahn rund um Hannover</h3>
<p>Am Kreuz Hannover-Ost treffen sich A2 und A7, dazu kommen der Messeschnellweg (A37) und die Schnellwege durch die Stadt. Bei einer Panne auf der Autobahn gilt immer: Warnblinker an, Warnweste anziehen, alle Insassen hinter die Leitplanke, dann das Warndreieck mit Abstand aufstellen. Erst danach anrufen. Sagen Sie uns die Autobahn, die Fahrtrichtung und das letzte Schild oder den Kilometer am Fahrbahnrand.</p>
<p>Auf dem Westschnellweg und dem Südschnellweg gibt es kaum Haltebuchten. Bleiben Sie dort im Auto angeschnallt, wenn Sie nicht sicher hinter eine Leitplanke kommen, und rufen Sie bei Gefahr zuerst die 110.</p>
<h3>Wo wir in Hannover helfen</h3>
<p>Wir vermitteln Pannenhilfe und Abschleppen in allen Stadtteilen, zum Beispiel in Linden, List, der Südstadt, Döhren, Vahrenwald, Bothfeld, Kirchrode oder Ricklingen. Auch rund um die Messe, am Flughafen in Langenhagen und in den Städten der Region wie Garbsen, Seelze, Laatzen und Lehrte rufen wir einen Betrieb aus der Nähe für Sie an.</p>
<p>Auf dem Weg nach Westen führt die A2 an Garbsen und Wunstorf vorbei Richtung <a href="/abschleppdienst-bad-nenndorf/">Bad Nenndorf</a> und <a href="/abschleppdienst-auetal/">Auetal</a>. Dort liegt unser Schwerpunkt, den ganzen Überblick finden Sie unter <a href="/regionen/">Regionen</a>.</p>
<h3>Typische Einsätze in Hannover</h3>
<ul>
<li>Batterie leer nach einer kalten Nacht: Starthilfe vor der Haustür oder auf dem Firmenparkplatz</li>
<li>Reifenpanne auf dem Weg zur Messe oder zum Flughafen</li>
<li>Auto nach einem Unfall nicht mehr fahrbereit: Abschleppen zur Werkstatt Ihrer Wahl</li>
<li>Transporter oder Wohnmobil liegengeblieben: Wir suchen einen Betrieb mit passendem Fahrzeug</li>
</ul>
<h3>Nachts, am Wochenende, an Feiertagen</h3>
<p>Pannen halten sich nicht an Öffnungszeiten. Wir sind rund um die Uhr erreichbar, auch nachts und an Feiertagen. Hat Ihre Werkstatt geschlossen, bringt der Betrieb das Auto auf Wunsch zuerst zu Ihnen nach Hause oder auf einen sicheren Stellplatz und am nächsten Werktag weiter. Sagen Sie uns am Telefon, was Ihnen lieber ist, dann planen wir das gleich mit ein.</p>
<p>Wichtig für die Werkstatt: Legen Sie Fahrzeugschein und Schlüssel bereit und notieren Sie, was vor der Panne passiert ist, zum Beispiel ein Geräusch, eine Warnleuchte oder Rauch. Das spart später Zeit bei der Fehlersuche.</p>
<h3>Was kostet ein Abschleppdienst in Hannover?</h3>
<p>Das hängt von der Strecke, der Uhrzeit und dem Fahrzeug ab. Sie hören den Preis am Telefon, bevor jemand losfährt, und entscheiden dann. Sind Sie im ADAC oder haben Sie einen Schutzbrief, rufen Sie zuerst dort an; dann zahlt meistens der Club oder die Versicherung.</p>
H
    faq => [
      ['Helfen Sie auch am Kreuz Hannover-Ost?', 'Ja. Sagen Sie uns, ob Sie auf der A2 oder der A7 stehen, die Fahrtrichtung und das letzte Schild. Sichern Sie zuerst die Unfallstelle und gehen Sie hinter die Leitplanke.'],
      ['Kommen Sie auch nach Langenhagen, Garbsen oder Laatzen?', 'Ja. Wir vermitteln Hilfe in der ganzen Region Hannover und auf der A2 Richtung Schaumburg.'],
      ['Mein Auto steht in einer Tiefgarage. Geht das?', 'Oft ja. Sagen Sie uns die Einfahrtshöhe, dann schicken wir einen Betrieb mit einem passenden, niedrigen Fahrzeug.'],
      ['Was kostet ein Abschleppdienst in Hannover?', 'Das hängt von Strecke, Uhrzeit und Fahrzeug ab. Den Preis nennen wir am Telefon, bevor jemand losfährt.'],
    ],
  },
);

sub region_faq_html {
  my ($slug) = @_; my $q = $R{$slug}{faq} or return '';
  my $out = qq{<h3>Häufige Fragen</h3><div class="faq">};
  $out .= qq{<details><summary>$_->[0]</summary><p>$_->[1]</p></details>} for @$q;
  return "$out</div>";
}
sub region_ld {
  my ($slug, $name) = @_;
  my $area = $R{$slug}{cities} ? '[' . join(',', map { qq{{"\@type":"City","name":"$_"}} } @{$R{$slug}{cities}}) . ']' : qq{{"\@type":"City","name":"$name"}};
  my $ld = qq{<script type="application/ld+json">{"\@context":"https://schema.org","\@type":"Service","serviceType":"Abschleppdienst und Pannenhilfe","name":"Abschleppdienst $name","url":"$SITE/abschleppdienst-$slug/","areaServed":$area,"provider":{"\@id":"$SITE/#business"},"availableChannel":{"\@type":"ServiceChannel","servicePhone":{"\@type":"ContactPoint","telephone":"$TELH","contactType":"customer service","hoursAvailable":"Mo-Su 00:00-23:59"}}}</script>\n};
  my $q = $R{$slug}{faq};
  if ($q) {
    my $items = join ',', map { (my $a1 = $_->[0]) =~ s/"/\\"/g; (my $b1 = $_->[1]) =~ s/"/\\"/g; qq{{"\@type":"Question","name":"$a1","acceptedAnswer":{"\@type":"Answer","text":"$b1"}}} } @$q;
    $ld .= qq{<script type="application/ld+json">{"\@context":"https://schema.org","\@type":"FAQPage","mainEntity":[$items]}</script>\n};
  }
  return $org_ld . $ld;
}
for my $r (@REGIONS) {
  my ($slug, $name) = @$r;
  page(
    path => "/abschleppdienst-$slug/", tab => '/regionen/',
    title => $R{$slug}{title}, desc => $R{$slug}{desc},
    h1 => "Abschleppdienst $name",
    ld => region_ld($slug, $name),
    feed => post(sub => "$name · 24/7", html => $R{$slug}{html} . region_faq_html($slug)) . $steps,
  );
}

page(
  path => '/regionen/', tab => '/regionen/',
  title => 'Einsatzgebiet: Schaumburg, A2, Hannover & Minden | Pannenhilfe Nord',
  desc  => 'Wo wir Pannenhilfe und Abschleppen vermitteln: Auetal, Rinteln, Bückeburg, Stadthagen, Bad Nenndorf, Minden, Hannover und die A2.',
  h1 => 'Einsatzgebiet',
  feed => post(sub => 'Regionen', html => '<h2>Hier vermitteln wir Hilfe</h2><p>Unser Schwerpunkt ist der Landkreis Schaumburg und die A2 zwischen Hannover und Bad Oeynhausen. Wählen Sie Ihren Ort:</p><ul>'
    . join('', map { qq{<li><a href="/abschleppdienst-$_->[0]/">Abschleppdienst $_->[1]</a></li>} } @REGIONS)
    . '<li><a href="/panne-a2/">Panne auf der A2</a></li><li><a href="/a2-rasthof-garbsen-lauenau/">Panne an der Raststätte Garbsen oder bei Lauenau</a></li></ul><p>Ihr Ort fehlt? Rufen Sie trotzdem an. Wir sagen Ihnen ehrlich, ob wir einen Partner in Ihrer Nähe haben.</p>'),
);

# ---------- Panne A2 Raststätte Garbsen / Lauenau ----------
page(
  path => '/a2-rasthof-garbsen-lauenau/', tab => '/panne-a2/',
  title => 'Panne A2 Rasthof Garbsen & Lauenau – Hilfe 24/7',
  desc  => 'Liegengeblieben an der Raststätte Garbsen oder bei Lauenau an der A2? So geben Sie den Standort richtig durch und bekommen schnell Hilfe.',
  h1 => 'Panne an der Raststätte Garbsen oder bei Lauenau',
  feed => post(sub => 'A2 · Garbsen – Bad Nenndorf – Lauenau', html => <<'H')
<h2>Gerade noch bis zur Raststätte geschafft</h2>
<p>Viele Pannen auf der A2 westlich von Hannover enden nicht auf dem Standstreifen, sondern auf einem Parkplatz: an der Raststätte Garbsen am Stadtrand von Hannover oder nach der Ausfahrt Lauenau zwischen Bad Nenndorf und Auetal. Das ist gut so. Auf einer Raststätte stehen Sie sicher, es gibt Licht, Toiletten und meistens etwas zu essen. Trotzdem gibt es ein paar Dinge, die Sie wissen sollten, damit der Abschleppwagen Sie schnell findet.</p>
<h3>Leuchtet eine Warnleuchte? Lieber zur Raststätte als auf den Standstreifen</h3>
<p>Wenn das Auto noch sicher fährt, etwa bei einer gelben Motorkontrollleuchte oder einem schleichenden Reifen, fahren Sie lieber vorsichtig bis zur nächsten Raststätte oder Ausfahrt, als auf dem Standstreifen anzuhalten. Bei roten Warnleuchten für Öldruck oder Bremsen, bei Rauch oder starkem Ruckeln gilt das nicht: dann sofort rechts ran, sichern und hinter die Leitplanke.</p>
<h3>Raststätte Garbsen: welche Seite?</h3>
<p>Die Raststätte Garbsen hat zwei Seiten, Garbsen Nord und Garbsen Süd, eine für jede Fahrtrichtung. Für Autos sind die beiden Seiten in der Regel nicht miteinander verbunden. Das heißt: Der Abschleppwagen muss in Ihrer Fahrtrichtung auf die Autobahn und in die richtige Raststätte fahren. Sagen Sie uns deshalb immer, in welche Richtung Sie unterwegs waren, also Richtung Hannover und Berlin oder Richtung Bad Nenndorf und Dortmund, und auf welcher Seite Sie stehen. Ein Live-Standort per WhatsApp klärt das sofort.</p>
<h3>Bei Lauenau von der Autobahn</h3>
<p>Weiter westlich, zwischen Bad Nenndorf und Auetal, fahren viele Fahrer bei Problemen an der Anschlussstelle Lauenau ab, um abseits der Autobahn sicher anzuhalten. Auch hier hilft uns eine genaue Angabe: an welcher Straße Sie stehen, ob auf einem Parkplatz oder am Straßenrand, und wie Sie dorthin gefahren sind. Von Lauenau aus ist ein Betrieb aus <a href="/abschleppdienst-bad-nenndorf/">Bad Nenndorf</a> oder <a href="/abschleppdienst-auetal/">Auetal</a> meist nicht weit.</p>
<h3>Wer Sie auf dem Rasthof abschleppen darf</h3>
<p>Auf der Raststätte stehen Sie nicht mehr auf der Fahrbahn. Sie entscheiden also selbst, wen Sie rufen: den ADAC, Ihren Schutzbrief oder uns. Anders ist es, wenn das Auto auf dem Standstreifen oder einer Fahrspur steht und die Polizei einen Abschleppdienst bestellt. Auf dem Parkplatz einer Raststätte gelten in der Regel Höchstparkdauern. Bleibt das Auto über Nacht stehen, fragen Sie an der Tankstelle oder beim Betreiber nach, oder lassen Sie es gleich abholen.</p>
<h3>Während Sie warten</h3>
<ul>
<li>Bleiben Sie im beleuchteten Bereich nahe dem Gebäude, besonders nachts.</li>
<li>Schlüssel, Fahrzeugschein und Ausweis bereithalten, Wertsachen aus dem Auto nehmen.</li>
<li>Kennzeichen, Farbe und Modell des Autos parat haben, damit der Fahrer es auf dem vollen LKW-Parkplatz schnell findet.</li>
<li>Kinder und Haustiere nicht zwischen den Parkreihen herumlaufen lassen, dort rangieren ständig LKW.</li>
</ul>
<h3>Mit Transporter, Wohnmobil oder Anhänger</h3>
<p>Auf dem LKW-Parkplatz der Raststätte stehen oft Transporter, Wohnmobile und Gespanne. Für sie braucht der Partner ein größeres Fahrzeug als für einen Kleinwagen. Nennen Sie uns deshalb Modell, ungefähres Gewicht und ob ein Anhänger dabei ist. Dann kommt gleich der passende Wagen, und niemand muss zweimal fahren.</p>
<h3>Und dann?</h3>
<p>Wir nennen Ihnen den Preis am Telefon, bevor jemand losfährt. Ihr Auto kommt in eine Werkstatt in der Nähe, etwa in Garbsen, <a href="/abschleppdienst-wunstorf-barsinghausen/">Wunstorf</a> oder <a href="/abschleppdienst-hannover/">Hannover</a>, oder zu Ihnen nach Hause. Brauchen Sie selbst eine Weiterfahrt, fragen Sie den Fahrer, ob er Sie bis zum nächsten Bahnhof mitnimmt. Die allgemeinen Regeln für eine Panne auf der Autobahn stehen unter <a href="/panne-a2/">Panne auf der A2</a>.</p>
H
);

# ---------- old URLs from the former Autohaus Bredemeier site ----------
my %OLD = (
  '/kfz-werkstatt-2/' => '/pannenhilfe/', '/fahrzeugtuning/' => '/pannenhilfe/',
  '/autovermietung/' => '/', '/vermietung/' => '/', '/mietmodelle-fuer-2-pferde/' => '/',
  '/mietmodelle-fuer-3-pferde/' => '/', '/unser-team/' => '/', '/karriere/' => '/',
);
for my $old (sort keys %OLD) {
  my $to = $OLD{$old}; my $file = ".${old}index.html";
  make_path(".$old") unless -d ".$old";
  open my $fh, '>:encoding(UTF-8)', $file or die "$file: $!";
  print $fh qq{<!doctype html>\n<html lang="de">\n<head>\n<meta charset="utf-8">\n<title>$SHORT</title>\n<link rel="canonical" href="$SITE$to">\n<meta http-equiv="refresh" content="0; url=$to">\n</head>\n<body><p>Diese Seite gibt es nicht mehr. Weiter zu <a href="$to">$SITE$to</a>.</p></body>\n</html>\n};
  close $fh;
}

# ---------- contact & legal ----------
page(
  path => '/kontakt/', tab => '/kontakt/',
  title => 'Kontakt – Pannenhilfe & Abschleppdienst 24/7 | Pannenhilfe Nord',
  desc  => "Rund um die Uhr erreichbar: Telefon $TELH, WhatsApp mit Standort oder E-Mail.",
  h1 => 'Kontakt',
  feed => post(sub => 'Kontakt', html => <<"H"),
<h2>So erreichen Sie uns</h2>
<ul>
<li><strong>Telefon (24/7):</strong> <a href="tel:$TEL">$TELH</a></li>
<li><strong>WhatsApp:</strong> <a href="$WA" target="_blank" rel="noopener">Nachricht mit Standort schicken</a></li>
<li><strong>E-Mail</strong> (nicht für Notfälle): <a href="mailto:$MAIL">$MAIL</a></li>
</ul>
<p>Bei einer Panne bitte immer anrufen oder WhatsApp schicken. E-Mails lesen wir nicht rund um die Uhr.</p>
H
);

page(
  path => '/impressum/', title => 'Impressum | Pannenhilfe Nord', desc => 'Impressum und Anbieterkennzeichnung.',
  h1 => 'Impressum',
  feed => post(sub => 'Rechtliches', bar => 0, html => <<"H"),
<h2>Impressum</h2>
<h3>Angaben gemäß § 5 DDG</h3>
<p>Abdelkarim El Farkouch<br>Einzelunternehmen nach belgischem Recht, Handelsname „Faster Depannage / Takeldienst“<br>Am Festungsgraben 2<br>10117 Berlin</p>
<p>Geschäftssitz: Boniverlei 172, 2650 Edegem, Belgien</p>
<h3>Kontakt</h3>
<p>Telefon: $TELH<br>E-Mail: $MAIL</p>
<h3>Unternehmensregister</h3>
<p>Eingetragen in der Zentralen Datenbank der Unternehmen Belgiens (KBO/BCE)<br>Unternehmensnummer: 1003.737.489</p>
<h3>Verantwortlich für den Inhalt nach § 18 Abs. 2 MStV</h3>
<p>Abdelkarim El Farkouch, Am Festungsgraben 2, 10117 Berlin</p>
<h3>Hinweis</h3>
<p>Wir vermitteln Pannenhilfe und Abschleppaufträge an selbstständige Betriebe aus der Region. Diese Website steht in keiner Verbindung zur ehemaligen Autohaus Bredemeier GmbH.</p>
H
);

page(
  path => '/datenschutzerklaerung/', title => 'Datenschutzerklärung | Pannenhilfe Nord', desc => 'Datenschutzerklärung.',
  h1 => 'Datenschutz',
  feed => post(sub => 'Rechtliches', bar => 0, html => <<"H"),
<h2>Datenschutzerklärung</h2>
<h3>1. Verantwortlicher</h3>
<p>Abdelkarim El Farkouch (Faster Depannage / Takeldienst), Am Festungsgraben 2, 10117 Berlin. E-Mail: <a href="mailto:$MAIL">$MAIL</a>, Telefon: $TELH.</p>
<h3>2. Hosting</h3>
<p>Diese Website wird über GitHub Pages bereitgestellt (GitHub, Inc., USA). Beim Aufruf verarbeitet GitHub technisch notwendige Daten, insbesondere die IP-Adresse. Rechtsgrundlage Art. 6 Abs. 1 lit. f DSGVO.</p>
<h3>3. Kontakt</h3>
<p>Bei Anruf, E-Mail oder WhatsApp verarbeiten wir Ihre Daten nur zur Bearbeitung der Anfrage und geben Standort und Fahrzeugdaten an den beauftragten Betrieb weiter. Art. 6 Abs. 1 lit. b DSGVO.</p>
<h3>4. Google Ads</h3>
<p>Conversion- und Anruf-Tracking nur nach Einwilligung im Cookie-Banner. Art. 6 Abs. 1 lit. a DSGVO.</p>
<h3>5. Rechte</h3>
<p>Auskunft, Berichtigung, Löschung, Widerspruch. Aufsicht: Gegevensbeschermingsautoriteit, Belgien.</p>
H
);

page(
  path => '/404.html', noindex => 1, title => 'Seite nicht gefunden | Pannenhilfe Nord', desc => 'Diese Seite gibt es nicht mehr.',
  h1 => $NAME,
  feed => post(sub => 'Seite nicht gefunden', html => '<h2>Diese Seite gibt es nicht mehr</h2><p>Die frühere Website des Autohauses Bredemeier ist nicht mehr online. Brauchen Sie Pannenhilfe oder einen Abschleppdienst? Rufen Sie uns an oder gehen Sie zur <a href="/">Startseite</a>.</p>'),
);

# ---------- sitemap & robots ----------
our @BUILT;
open my $sm, '>:encoding(UTF-8)', 'sitemap.xml' or die $!;
print $sm qq{<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n};
print $sm "  <url><loc>$SITE$_</loc><lastmod>$TODAY</lastmod></url>\n" for @BUILT;
print $sm "</urlset>\n"; close $sm;
open my $rb, '>', 'robots.txt' or die $!;
print $rb "User-agent: *\nAllow: /\n\nSitemap: $SITE/sitemap.xml\n"; close $rb;
print scalar(@BUILT), " pages in sitemap\n";
