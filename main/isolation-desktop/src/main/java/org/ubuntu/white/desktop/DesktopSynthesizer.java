package org.ubuntu.white.desktop;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Pos;
import javafx.scene.Cursor;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.Dragboard;
import javafx.scene.input.KeyCode;
import javafx.scene.input.TransferMode;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** Full-window Ubuntu White Linux-style desktop preview. */
public final class DesktopSynthesizer {
    private static final String MANIFEST = "desktop-preview.json";
    private static final String WALLPAPER = "mediate-ubuntu-white-edition-001.jpeg";
    private static final int ICON_SIZE = 64;
    private static final double GRID_X = 150;
    private static final double GRID_Y = 112;
    private static final double MARGIN_X = 28;
    private static final double MARGIN_Y = 28;
    private static final String[] DEFAULT_LABELS = {"Desktop","Documents","Downloads","Music","Pictures","Public","Templates","Videos","Trash","Applications","Computer","Settings"};
    private static final String[] DEFAULT_ICONS = {"icon-001.png","icon-002.png","icon-003.png","icon-004.png","icon-005.png","icon-006.png","icon-007.png","icon-008.png","icon-009.png","icon-010.png","icon-011.png","icon-012.png"};

    private static final class DesktopApp extends Application {
        @Override public void start(Stage stage) {
            stage.setTitle("Ubuntu White — Desktop Synthesizer");
            StackPane desktop = new StackPane(); desktop.setStyle("-fx-background-color: black;"); buildDesktop(desktop);
            BorderPane shell = new BorderPane(desktop);
            Label top = new Label("  Applications     Files     Settings"); top.setStyle("-fx-background-color: rgba(255,255,255,0.90); -fx-text-fill: #333333; -fx-padding: 10px 18px; -fx-font-size: 14px;"); shell.setTop(top);
            Label bottom = new Label("  Ubuntu White • Desktop Synthesizer    •    13 manifest icons    •    PNG/JPEG sources only    •    ESC: Exit"); bottom.setStyle("-fx-background-color: rgba(255,255,255,0.88); -fx-text-fill: #333333; -fx-padding: 8px 14px; -fx-font-size: 12px;"); shell.setBottom(bottom);
            Scene scene = new Scene(shell, 1280, 800);
            scene.setOnKeyPressed(e -> { if (e.getCode() == KeyCode.ESCAPE) Platform.exit(); });
            stage.setScene(scene);
            stage.setFullScreenExitHint("Press ESC to exit Ubuntu White Desktop");
            stage.setFullScreen(true);
            stage.show();
            Platform.runLater(stage::requestFocus);
        }
    }

    private static void buildDesktop(StackPane desktop) {
        Image wallpaper = loadWallpaper();
        if (wallpaper != null) { ImageView bg=new ImageView(wallpaper); bg.setPreserveRatio(true); bg.setSmooth(true); bg.setMouseTransparent(true); bg.setManaged(false); desktop.getChildren().add(bg); desktop.widthProperty().addListener((o,a,b)->fitWallpaper(bg,desktop)); desktop.heightProperty().addListener((o,a,b)->fitWallpaper(bg,desktop)); Platform.runLater(()->fitWallpaper(bg,desktop)); }
        Pane icons=new Pane(); icons.setPickOnBounds(false); desktop.getChildren().add(icons);
        List<IconSpec> specs=loadManifest(); for(int i=0;i<specs.size();i++) icons.getChildren().add(createIcon(specs.get(i),i)); installExternalDrop(icons);
    }

    private static List<IconSpec> loadManifest() {
        String json=null; Path[] paths={Path.of("main/isolation-desktop/src/main/resources",MANIFEST),Path.of("src/main/resources",MANIFEST),Path.of(MANIFEST),Path.of("../src/main/resources",MANIFEST),Path.of("../../src/main/resources",MANIFEST)};
        for(Path p:paths) if(Files.isRegularFile(p)) try{json=Files.readString(p);break;}catch(Exception ignored){}
        List<IconSpec> result=new ArrayList<>();
        if(json!=null){Matcher m=Pattern.compile("\\{\\s*\\\"id\\\"\\s*:\\s*\\\"([^\\\"]+)\\\"\\s*,\\s*\\\"label\\\"\\s*:\\s*\\\"([^\\\"]+)\\\"\\s*,\\s*\\\"source\\\"\\s*:\\s*\\\"([^\\\"]+)\\\"\\s*\\}").matcher(json);while(m.find()){String s=m.group(3).toLowerCase();if(s.endsWith(".png")||s.endsWith(".jpeg"))result.add(new IconSpec(m.group(1),m.group(2),m.group(3)));}}
        if(result.size()!=13){result.clear();for(int i=0;i<12;i++)result.add(new IconSpec("desktop-"+(i+1),DEFAULT_LABELS[i],"ubuntu-white/icons/set-002/"+DEFAULT_ICONS[i]));result.add(new IconSpec("smaug","Smaug","ubuntu-white/icons/smaug/smaug-icon-001.jpeg"));}
        return result;
    }

    private static Image loadWallpaper(){Path[] p={Path.of("images",WALLPAPER),Path.of("ubuntu-white/images",WALLPAPER),Path.of("../../images",WALLPAPER)};for(Path x:p)if(Files.isRegularFile(x))return new Image(x.toAbsolutePath().toUri().toString());return null;}
    private static Path resolve(String source){Path[] p={Path.of(source),Path.of("..",source),Path.of("..","..",source),Path.of("..","..","..",source),Path.of("..","..","..","..",source)};for(Path x:p)if(Files.isRegularFile(x))return x.toAbsolutePath();return null;}
    private static VBox createIcon(IconSpec spec,int index){VBox box=new VBox(5);box.setAlignment(Pos.CENTER);box.setPrefSize(120,88);box.setCursor(Cursor.OPEN_HAND);Path p=resolve(spec.source);if(p!=null){ImageView iv=new ImageView(new Image(p.toUri().toString()));iv.setFitWidth(ICON_SIZE);iv.setFitHeight(ICON_SIZE);iv.setPreserveRatio(true);iv.setSmooth(true);iv.setMouseTransparent(true);box.getChildren().add(iv);}else{Label missing=new Label("MISSING");missing.setStyle("-fx-text-fill:white;-fx-font-size:12px;-fx-font-weight:bold;");box.getChildren().add(missing);}Label l=new Label(spec.label);l.setStyle("-fx-text-fill:white;-fx-font-size:13px;-fx-font-weight:bold;-fx-effect:dropshadow(gaussian,black,3,0.7,0,1);");box.getChildren().add(l);int columns=5;box.relocate(MARGIN_X+(index%columns)*GRID_X,MARGIN_Y+(index/columns)*GRID_Y);installIconDrag(box);return box;}
    private static void fitWallpaper(ImageView bg,StackPane d){double w=d.getWidth(),h=d.getHeight(),iw=bg.getImage().getWidth(),ih=bg.getImage().getHeight();if(w<=0||h<=0||iw<=0||ih<=0)return;double s=Math.max(w/iw,h/ih),rw=iw*s,rh=ih*s;bg.setFitWidth(rw);bg.setFitHeight(rh);bg.setTranslateX((w-rw)/2);bg.setTranslateY((h-rh)/2);}
    private static void installIconDrag(VBox icon){final double[] press=new double[2],origin=new double[2];icon.setOnMousePressed(e->{press[0]=e.getSceneX();press[1]=e.getSceneY();origin[0]=icon.getLayoutX();origin[1]=icon.getLayoutY();icon.setCursor(Cursor.CLOSED_HAND);icon.toFront();});icon.setOnMouseDragged(e->icon.relocate(origin[0]+e.getSceneX()-press[0],origin[1]+e.getSceneY()-press[1]));icon.setOnMouseReleased(e->{double x=MARGIN_X+Math.round((icon.getLayoutX()-MARGIN_X)/GRID_X)*GRID_X,y=MARGIN_Y+Math.round((icon.getLayoutY()-MARGIN_Y)/GRID_Y)*GRID_Y;icon.relocate(Math.max(MARGIN_X,x),Math.max(MARGIN_Y,y));icon.setCursor(Cursor.OPEN_HAND);});}
    private static void installExternalDrop(Pane d){d.setOnDragOver(e->{if(e.getDragboard().hasFiles())e.acceptTransferModes(TransferMode.COPY);e.consume();});d.setOnDragDropped(e->{Dragboard b=e.getDragboard();boolean ok=false;if(b.hasFiles()){List<Path> dropped=new ArrayList<>();for(var f:b.getFiles())dropped.add(f.toPath());System.out.println("Ubuntu White Desktop received: "+dropped);ok=!dropped.isEmpty();}e.setDropCompleted(ok);e.consume();});}
    private record IconSpec(String id,String label,String source){}

    public static void main(String[] args){Application.launch(DesktopApp.class,args);}
}
