module Handler.NewMuebles where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Text.Markdown (markdownField)

articuloFormPost:: Maybe Articulo -> AForm Handler Articulo
articuloFormPost mArticulo = Articulo 
  <$> areq textField "nombre" (articuloNombre <$> mArticulo)
  <*> areq markdownField "Descripcion Larga" (articuloDescripcionLarga <$> mArticulo)
  <*> areq textField "DescripcionCorta" (articuloDescripcionCorta <$> mArticulo)
  <*> areq intField "Precio" (articuloPrecio <$> mArticulo)
  
getNewMueblesR :: Handler Html
getNewMueblesR = do
  (widget, entype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm $ articuloFormPost Nothing
  defaultLayout $ do
    $(widgetFile "articulo/new") 
  
postNewMueblesR :: Handler Html
postNewMueblesR = do
  ((result,widget), entype) <- runFormPost $
                                renderBootstrap3 BootstrapBasicForm $ articuloFormPost Nothing
  case result of
     FormSuccess articulo -> do
                            bid <- runDB $ insert articulo
                            redirect (HomeR)
     _ -> defaultLayout $ do
       $(widgetFile "articulo/new")
     
