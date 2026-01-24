use Test::Whitespaces {

    dirs => [
        '.',
    ],

    ignore => [
        qr{\.buildx-cache/}
    ],

};
