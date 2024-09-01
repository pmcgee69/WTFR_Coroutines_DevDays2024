unit U_Patterns;

interface

type
  Cell_types = (TL_Corner, TR_Corner,
                BL_Corner, BR_Corner,
                T_Edge,    L_Edge,
                R_Edge,    B_edge,     Middle);

const
  Cell_patterns : array [Cell_types] of string = ( '----.1-11',
                                                   '---1.-11-',
                                                   '-11-.1---',
                                                   '11-1.----',
                                                   '---1.1111',
                                                   '-11-.1-11',
                                                   '11-1.-11-',
                                                   '1111.1---',
                                                   '1111.1111'  );
implementation

{   Define cell types
// - - - - - - - - - - - - - - - -

    TL Corner [ - - - ,
                - ○ 1 ,
                - 1 1 ];

    TR Corner [ - - - ,
                1 ○ - ,
                1 1 - ];

    BL Corner [ - 1 1 ,
                - ○ 1 ,
                - - - ];

    BR Corner [ 1 1 - ,
                1 ○ - ,
                - - - ];

// - - - - - - - - - - - - - - - -

    T  Edge   [ - - - ,
                1 ○ 1 ,
                1 1 1 ];

    L  Edge   [ - 1 1 ,
                - ○ 1 ,
                - 1 1 ];

    R  Edge   [ 1 1 - ,
                1 ○ - ,
                1 1 - ];

    B  edge   [ 1 1 1 ,
                1 ○ 1 ,
                - - - ];
// - - - - - - - - - - - - - - - -

    Middle    [ 1 1 1 ,
                1 ○ 1 ,
                1 1 1 ];

// - - - - - - - - - - - - - - - -

    TL_Corner, '- - - - 0 1 - 1 1'
    TR_Corner, '- - - 1 0 - 1 1 -'
    BL_Corner, '- 1 1 - 0 1 - - -'
    BR_Corner, '1 1 - 1 0 - - - -'
    T_Edge   , '- - - 1 0 1 1 1 1'
    L_Edge   , '- 1 1 - 0 1 - 1 1'
    R_Edge   , '1 1 - 1 0 - 1 1 -'
    B_edge   , '1 1 1 1 0 1 - - -'
    Middle   , '1 1 1 1 0 1 1 1 1';

}


end.
