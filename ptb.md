# 1) register_user
sui client call \
  --package 0x27e1a6fc0dcc22a454cf206cdd1f650b8aa2dc287b8d9d551657f304d6db08cb \
  --module profile \
  --function register_user \
  --args 0xb2849a0088c00a1d8f03e255ffec5d4affaa9623e07fac9d7fb972bc3fb0fc11



  # 2) create_new_collection
sui client call \
  --package 0x27e1a6fc0dcc22a454cf206cdd1f650b8aa2dc287b8d9d551657f304d6db08cb \
  --module profile \
  --function create_new_collection \
  --args \
    0xb2849a0088c00a1d8f03e255ffec5d4affaa9623e07fac9d7fb972bc3fb0fc11 \
    0x504f0e61febd67811dfdf33cfdc384f11b0ff0120ef35a3b422b76e4be2f3d64 \
    "Science 2025"


# 3) add_flash_card
sui client call \
  --package 0x27e1a6fc0dcc22a454cf206cdd1f650b8aa2dc287b8d9d551657f304d6db08cb \
  --module profile \
  --function add_flash_card \
  --args \
    0xb2849a0088c00a1d8f03e255ffec5d4affaa9623e07fac9d7fb972bc3fb0fc11 \
    0xbebc3b684b8393b47657fdd9fd5179f8c07baa8d56da8a6f17f590bf0694912c \
    0x504f0e61febd67811dfdf33cfdc384f11b0ff0120ef35a3b422b76e4be2f3d64 \
    0xbebc3b684b8393b47657fdd9fd5179f8c07baa8d56da8a6f17f590bf0694912c \
    "What is 2+2?" 
    "4"
