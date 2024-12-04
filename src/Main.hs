
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where 

import qualified GI.Gtk as Gtk
import Data.GI.Base
import qualified Data.Text as T
import System.Process

type Name = String
type Image = FilePath
type ButtonList =  [(Name,Image)]

buttonList :: Gtk.Grid -> Gtk.Window -> ButtonList -> IO ()
buttonList grid win buttonlist = mapM_ (uncurry (mkButton  grid win) ) buttonlist

mkButton :: Gtk.Grid -> Gtk.Window -> Name -> Image -> IO () 
mkButton grid win name image = do

    img <- Gtk.imageNewFromFile image
    btn <- Gtk.buttonNew
    Gtk.buttonSetRelief btn Gtk.ReliefStyleNone
    Gtk.buttonSetImage btn $ Just img
    label <- Gtk.labelNew Nothing
    Gtk.labelSetMarkup label  $ T.pack ("<b>"++  name ++ "</b>")
    Gtk.widgetSetHexpand btn False
    case name of 
           "Cancel" -> do  
              btn `on` #clicked $ Gtk.mainQuit
              Gtk.gridAttach grid btn 0 0 1 1
              Gtk.gridAttach grid label 0 1 1 1
           "Hibernate" -> do 
              btn `on` #clicked $ do
                  callCommand  "sudo systemctl hibernate"
                  Gtk.mainQuit
              Gtk.gridAttach grid btn 1 0 1 1
              Gtk.gridAttach grid label 1 1 1 1
           "Lock" -> do 
              btn `on` #clicked $ do
                  callCommand  "loginctl lock-session"
                  Gtk.mainQuit
              Gtk.gridAttach grid btn 2 0 1 1
              Gtk.gridAttach grid label 2 1 1 1
           "Logout" -> do 
              btn `on` #clicked $ do
                  callCommand  "uwsm stop"
                  Gtk.mainQuit
              Gtk.gridAttach grid btn 3 0 1 1
              Gtk.gridAttach grid label 3 1 1 1
           "Reboot" -> do 
              btn `on` #clicked $ do
                  callCommand  "sudo reboot now"
                  Gtk.mainQuit
              Gtk.gridAttach grid btn 4 0 1 1
              Gtk.gridAttach grid label 4 1 1 1
           "Shutdown" -> do 
              btn `on` #clicked $ do
                  callCommand  "sudo shutdown now"
                  Gtk.mainQuit
              Gtk.gridAttach grid btn 5 0 1 1
              Gtk.gridAttach grid label 5 1 1 1
           "Suspend" -> do 
              btn `on` #clicked $ do
                  callCommand  "loginctl lock-session && sudo systemctl suspend"
                  Gtk.mainQuit
              Gtk.gridAttach grid btn 6 0 1 1
              Gtk.gridAttach grid label  6 1 1 1
    return ()
                            
          
    
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
    buttonList grid win [ ("Cancel","./img/cancel.png"),
                    ("Hibernate","./img/hibernate.png"),
                    ("Lock","./img/lock.png"),
                    ("Logout","./img/logout.png"),
                    ("Reboot","./img/reboot.png"),
                    ("Shutdown","./img/shutdown.png"),
                    ("Suspend","./img/suspend.png")
                    ]

    
    
    


    Gtk.onWidgetDestroy win Gtk.mainQuit
    #showAll win 
    Gtk.main
