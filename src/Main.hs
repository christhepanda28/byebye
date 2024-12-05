{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where 

import qualified GI.Gtk as Gtk
import Data.GI.Base
import qualified Data.Text as T
import System.Process
import Data.Int

type Command = String
type Name = String
type Image = FilePath
type ButtonList =  [(Name, Image, Command)]

mkButtons :: Gtk.Grid -> Gtk.Window -> ButtonList -> IO ()
mkButtons grid win buttonlist = mapM_ (\(position, (name, image, command)) -> do
    img <- Gtk.imageNewFromFile image
    btn <- Gtk.buttonNew
    Gtk.buttonSetRelief btn Gtk.ReliefStyleNone
    Gtk.buttonSetImage btn $ Just img
    label <- Gtk.labelNew Nothing
    Gtk.labelSetMarkup label  $ T.pack ("<b>"++  name ++ "</b>")
    Gtk.widgetSetHexpand btn False 
    btn `on` #clicked $ do
        callCommand command
        Gtk.mainQuit
    Gtk.gridAttach grid btn position 0 1 1
    Gtk.gridAttach grid label position 1 1 1
    return ()
    ) (zip [0..] buttonlist)            
              
main :: IO ()
main = do 
    Gtk.init Nothing    
    win <- Gtk.windowNew Gtk.WindowTypeToplevel
    Gtk.setContainerBorderWidth win 10
    Gtk.setWindowTitle win "ByeBye"
    Gtk.setWindowResizable win False
    Gtk.setWindowDefaultWidth win 750
    Gtk.setWindowDefaultHeight win 225
    Gtk.setWindowWindowPosition win Gtk.WindowPositionCenter
    Gtk.windowSetDecorated win False

    grid <- Gtk.gridNew
    Gtk.gridSetColumnSpacing grid 10
    Gtk.gridSetRowSpacing grid 10
    Gtk.gridSetColumnHomogeneous grid True
    Gtk.containerAdd win grid
    mkButtons grid win [ ("Cancel","./img/cancel.png",""),
                    ("Hibernate","./img/hibernate.png","sudo systemctl hibernate"),
                    ("Lock","./img/lock.png","loginctl lock-session"),
                    ("Logout","./img/logout.png","loginctl terminate-user ''"),
                    ("Reboot","./img/reboot.png","sudo reboot now"),
                    ("Shutdown","./img/shutdown.png","sudo shutdown now"),
                    ("Suspend","./img/suspend.png","sudo systemctl suspend")
                    ]
    Gtk.onWidgetDestroy win Gtk.mainQuit
    #showAll win 
    Gtk.main
