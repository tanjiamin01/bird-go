
import 'dart:io';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:googlemapstry/widget_copy/button_widget.dart';
import'package:firebase_storage/firebase_storage.dart';
import'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../location copy.dart';
import '../photo_copy.dart';
import 'package:dropdown_search/dropdown_search.dart';



class TextfieldGeneralWidget extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<TextfieldGeneralWidget> {
  bool pressGeoON = false;
  final NameController = TextEditingController();
  final DescriptionController = TextEditingController();
  final numberController = TextEditingController();
  String password = '';
  bool isPasswordVisible = false;
  Location location = new Location();
  var position;
  var ListOfBirds = ['King Quail; Excalfactoria chinensis', 'Red Junglefowl; Gallus gallus', 'Wandering Whistling Duck; Dendrocygna arcuata', 'Lesser Whistling Duck; Dendrocygna javanica', 'Cotton Pygmy Goose; Nettapus coromandelianus', 'Garganey; Spatula querquedula', 'Northern Shoveler; Spatula clypeata', 'Gadwall; Mareca strepera', 'Eurasian Wigeon; Mareca penelope', 'Northern Pintail; Anas acuta', 'Tufted Duck; Aythya fuligula', 'Malaysian Eared Nightjar; Lyncornis temminckii', 'Grey Nightjar; Caprimulgus jotaka', 'Large-tailed Nightjar; Caprimulgus macrurus', 'Savanna Nightjar; Caprimulgus affinis', 'Grey-rumped Treeswift; Hemiprocne longipennis', 'Whiskered Treeswift; Hemiprocne comata', 'Plume-toed Swiftlet; Collocalia affinis', 'Black-nest Swiftlet; Aerodramus maximus', "Germain's Swiftlet; Aerodramus germani", 'Silver-rumped Spinetail; Rhaphidura leucopygialis', 'White-throated Needletail; Hirundapus caudacutus', 'Silver-backed Needletail; Hirundapus cochinchinensis', 'Brown-backed Needletail; Hirundapus giganteus', 'Asian Palm Swift; Cypsiurus balasiensis', 'Common Swift; Apus apus', 'Pacific Swift; Apus pacificus', 'House Swift; Apus nipalensis', 'Greater Coucal; Centropus sinensis', 'Lesser Coucal; Centropus bengalensis', 'Chestnut-bellied Malkoha; Phaenicophaeus sumatranus', 'Chestnut-winged Cuckoo; Clamator coromandus', 'Jacobin Cuckoo; Clamator jacobinus', 'Asian Koel; Eudynamys scolopaceus', 'Asian Emerald Cuckoo; Chrysococcyx maculatus', 'Violet Cuckoo; Chrysococcyx xanthorhynchus', "Horsfield's Bronze Cuckoo; Chrysococcyx basalis", 'Little Bronze Cuckoo; Chrysococcyx minutillus', 'Banded Bay Cuckoo; Cacomantis sonneratii', 'Plaintive Cuckoo; Cacomantis merulinus', 'Rusty-breasted Cuckoo; Cacomantis sepulcralis', 'Square-tailed Drongo-Cuckoo; Surniculus lugubris', 'Large Hawk-Cuckoo; Hierococcyx sparverioides', 'Malaysian Hawk-Cuckoo; Hierococcyx fugax', "Hodgson's Hawk-Cuckoo; Hierococcyx nisicolor", 'Indian Cuckoo; Cuculus micropterus', 'Himalayan Cuckoo; Cuculus saturatus', 'Oriental Turtle Dove; Streptopelia orientalis', 'Red Collared Dove; Streptopelia tranquebarica', 'Common Emerald Dove; Chalcophaps indica', 'Zebra Dove; Geopelia striata', 'Cinnamon-headed Green Pigeon; Treron fulvicollis', 'Little Green Pigeon; Treron olax', 'Orange-breasted Green Pigeon; Treron bicinctus', 'Thick-billed Green Pigeon; Treron curvirostra', 'Jambu Fruit Dove; Ptilinopus jambu', 'Green Imperial Pigeon; Ducula aenea', 'Mountain Imperial Pigeon; Ducula badia', 'Pied Imperial Pigeon; Ducula bicolor', 'Masked Finfoot; Heliopais personatus', 'Red-legged Crake; Rallina fasciata', 'Slaty-legged Crake; Rallina eurizonoides', 'Slaty-breasted Rail; Lewinia striata', 'White-breasted Waterhen; Amaurornis phoenicurus', "Baillon's Crake; Zapornia pusilla", 'Ruddy-breasted Crake; Zapornia fusca', 'Band-bellied Crake; Zapornia paykullii', 'White-browed Crake; Poliolimnas cinereus', 'Watercock; Gallicrex cinerea', 'Grey-headed Swamphen; Porphyrio poliocephalus', 'Common Moorhen; Gallinula chloropus', 'Eurasian Coot; Fulica atra', 'Little Grebe; Tachybaptus ruficollis', 'Barred Buttonquail; Turnix suscitator', 'Beach Stone-curlew; Esacus magnirostris', 'Black-winged Stilt; Himantopus himantopus', 'Pied Stilt; Himantopus leucocephalus', 'Grey-headed Lapwing; Vanellus cinereus', 'Red-wattled Lapwing; Vanellus indicus', 'Pacific Golden Plover; Pluvialis fulva', 'Grey Plover; Pluvialis squatarola', 'Common Ringed Plover; Charadrius hiaticula', 'Little Ringed Plover; Charadrius dubius', 'Kentish Plover; Charadrius alexandrinus', 'White-faced Plover; Charadrius dealbatus', 'Malaysian Plover; Charadrius peronii', 'Lesser Sand Plover; Charadrius mongolus', 'Greater Sand Plover; Charadrius leschenaultii', 'Oriental Plover; Charadrius veredus', 'Greater Painted-snipe; Rostratula benghalensis', 'Pheasant-tailed Jacana; Hydrophasianus chirurgus', 'Eurasian Whimbrel; Numenius phaeopus', 'Little Curlew; Numenius minutus', 'Far Eastern Curlew; Numenius madagascariensis', 'Eurasian Curlew; Numenius arquata', 'Bar-tailed Godwit; Limosa lapponica', 'Black-tailed Godwit; Limosa limosa', 'Ruddy Turnstone; Arenaria interpres', 'Great Knot; Calidris tenuirostris', 'Red Knot; Calidris canutus', 'Ruff; Calidris pugnax', 'Broad-billed Sandpiper; Calidris falcinellus', 'Sharp-tailed Sandpiper; Calidris acuminata', 'Curlew Sandpiper; Calidris ferruginea', "Temminck's Stint; Calidris temminckii", 'Long-toed Stint; Calidris subminuta', 'Spoon-billed Sandpiper; Calidris pygmaea', 'Red-necked Stint; Calidris ruficollis', 'Sanderling; Calidris alba', 'Little Stint; Calidris minuta', 'Pectoral Sandpiper; Calidris melanotos', 'Asian Dowitcher; Limnodromus semipalmatus', 'Pin-tailed Snipe; Gallinago stenura', "Swinhoe's Snipe; Gallinago megala", 'Common Snipe; Gallinago gallinago', 'Terek Sandpiper; Xenus cinereus', 'Red-necked Phalarope; Phalaropus lobatus', 'Common Sandpiper; Actitis hypoleucos', 'Green Sandpiper; Tringa ochropus', 'Grey-tailed Tattler; Tringa brevipes', 'Common Redshank; Tringa totanus', 'Marsh Sandpiper; Tringa stagnatilis', 'Wood Sandpiper; Tringa glareola', 'Spotted Redshank; Tringa erythropus', 'Common Greenshank; Tringa nebularia', "Nordmann's Greenshank; Tringa guttifer", 'Oriental Pratincole; Glareola maldivarum', 'Small Pratincole; Glareola lactea', 'Brown-headed Gull; Chroicocephalus brunnicephalus', 'Black-headed Gull; Chroicocephalus ridibundus', 'Gull-billed Tern; Gelochelidon nilotica', 'Caspian Tern; Hydroprogne caspia', 'Greater Crested Tern; Thalasseus bergii', 'Lesser Crested Tern; Thalasseus bengalensis', 'Little Tern; Sternula albifrons', 'Aleutian Tern; Onychoprion aleuticus', 'Bridled Tern; Onychoprion anaethetus', 'Black-naped Tern; Sterna sumatrana', 'Common Tern; Sterna hirundo', 'Whiskered Tern; Chlidonias hybrida', 'White-winged Tern; Chlidonias leucopterus', 'Parasitic Jaeger; Stercorarius parasiticus', 'Long-tailed Jaeger; Stercorarius longicaudus', "Swinhoe's Storm Petrel; Oceanodroma monorhis", 'Short-tailed Shearwater; Ardenna tenuirostris', 'Asian Openbill; Anastomus oscitans', 'Lesser Adjutant; Leptoptilos javanicus', 'Lesser Frigatebird; Fregata ariel', 'Red-footed Booby; Sula sula', 'Brown Booby; Sula leucogaster', 'Oriental Darter; Anhinga melanogaster', 'Glossy Ibis; Plegadis falcinellus', 'Yellow Bittern; Ixobrychus sinensis', "Von Schrenck's Bittern; Ixobrychus eurhythmus", 'Cinnamon Bittern; Ixobrychus cinnamomeus', 'Black Bittern; Ixobrychus flavicollis', 'Malayan Night Heron; Gorsachius melanolophus', 'Black-crowned Night Heron; Nycticorax nycticorax', 'Striated Heron; Butorides striata', 'Indian Pond Heron; Ardeola grayii', 'Chinese Pond Heron; Ardeola bacchus', 'Javan Pond Heron; Ardeola speciosa', 'Eastern Cattle Egret; Bubulcus coromandus', 'Grey Heron; Ardea cinerea', 'Great-billed Heron; Ardea sumatrana', 'Purple Heron; Ardea purpurea', 'Great Egret; Ardea alba', 'Intermediate Egret; Ardea intermedia', 'Little Egret; Egretta garzetta', 'Pacific Reef Heron; Egretta sacra', 'Chinese Egret; Egretta eulophotes', 'Western Osprey; Pandion haliaetus', 'Black-winged Kite; Elanus caeruleus', 'Crested Honey Buzzard; Pernis ptilorhynchus', "Jerdon's Baza; Aviceda jerdoni", 'Black Baza; Aviceda leuphotes', 'Himalayan Vulture; Gyps himalayensis', 'Crested Serpent Eagle; Spilornis cheela', 'Short-toed Snake Eagle; Circaetus gallicus', 'Bat Hawk; Macheiramphus alcinus', 'Changeable Hawk-Eagle; Nisaetus cirrhatus', 'Rufous-bellied Eagle; Lophotriorchis kienerii', 'Greater Spotted Eagle; Clanga clanga', 'Booted Eagle; Hieraaetus pennatus', 'Steppe Eagle; Aquila nipalensis', 'Eastern Imperial Eagle; Aquila heliaca', 'Crested Goshawk; Accipiter trivirgatus', 'Shikra; Accipiter badius', 'Chinese Sparrowhawk; Accipiter soloensis', 'Japanese Sparrowhawk; Accipiter gularis', 'Besra; Accipiter virgatus', 'Eurasian Sparrowhawk; Accipiter nisus', 'Eastern Marsh Harrier; Circus spilonotus', 'Pied Harrier; Circus melanoleucos', 'Black Kite; Milvus migrans', 'Brahminy Kite; Haliastur indus', 'White-bellied Sea Eagle; Haliaeetus leucogaster', 'Grey-headed Fish Eagle; Haliaeetus ichthyaetus', 'Grey-faced Buzzard; Butastur indicus', 'Common Buzzard; Buteo buteo', 'Eastern Barn Owl; Tyto javanica', 'Sunda Scops Owl; Otus lempiji', 'Oriental Scops Owl; Otus sunia', 'Barred Eagle-owl; Bubo sumatranus', 'Buffy Fish Owl; Ketupa ketupu', 'Spotted Wood Owl; Strix seloputo', 'Brown Wood Owl; Strix leptogrammica', 'Brown Hawk-Owl; Ninox scutulata', 'Northern Boobook; Ninox japonica', 'Short-eared Owl; Asio flammeus', 'Oriental Pied Hornbill; Anthracoceros albirostris', 'Black Hornbill; Anthracoceros malayanus', 'Oriental Dollarbird; Eurystomus orientalis', 'Stork-billed Kingfisher; Pelargopsis capensis', 'Ruddy Kingfisher; Halcyon coromanda', 'White-throated Kingfisher; Halcyon smyrnensis', 'Black-capped Kingfisher; Halcyon pileata', 'Blue-eared Kingfisher; Alcedo meninting', 'Common Kingfisher; Alcedo atthis', 'Oriental Dwarf Kingfisher; Ceyx erithaca', 'Pied Kingfisher; Ceryle rudis', 'Blue-tailed Bee-eater; Merops philippinus', 'Blue-throated Bee-eater; Merops viridis', 'Lineated Barbet; Psilopogon lineatus', 'Red-crowned Barbet; Psilopogon rafflesii', 'Coppersmith Barbet; Psilopogon haemacephalus', 'Sunda Pygmy Woodpecker; Yungipicus moluccensis', 'White-bellied Woodpecker; Dryocopus javensis', 'Banded Woodpecker; Chrysophlegma miniaceum', 'Crimson-winged Woodpecker; Picus puniceus', 'Laced Woodpecker; Picus vittatus', 'Common Flameback; Dinopium javanense', 'Rufous Woodpecker; Micropternus brachyurus', 'Buff-rumped Woodpecker; Meiglyptes tristis', 'Great Slaty Woodpecker; Mulleripicus pulverulentus', 'Lesser Kestrel; Falco naumanni', 'Common Kestrel; Falco tinnunculus', 'Amur Falcon; Falco amurensis', 'Eurasian Hobby; Falco subbuteo', 'Peregrine Falcon; Falco peregrinus', 'Tanimbar Corella; Cacatua goffiniana', 'Yellow-crested Cockatoo; Cacatua sulphurea', 'Blue-rumped Parrot; Psittinus cyanurus', 'Red-breasted Parakeet; Psittacula alexandri', 'Long-tailed Parakeet; Psittacula longicauda', 'Rose-ringed Parakeet; Psittacula krameri', 'Coconut Lorikeet; Trichoglossus haematodus', 'Blue-crowned Hanging Parrot; Loriculus galgulus', 'Black-and-red Broadbill; Cymbirhynchus macrorhynchos', 'Green Broadbill; Calyptomena viridis', 'Hooded Pitta; Pitta sordida', 'Fairy Pitta; Pitta nympha', 'Blue-winged Pitta; Pitta moluccensis', 'Mangrove Pitta; Pitta megarhyncha', 'Golden-bellied Gerygone; Gerygone sulphurea', 'Black-winged Flycatcher-shrike; Hemipus hirundinaceus', 'Large Woodshrike; Tephrodornis virgatus', 'Common Iora; Aegithina tiphia', 'Scarlet Minivet; Pericrocotus speciosus', 'Ashy Minivet; Pericrocotus divaricatus', 'Pied Triller; Lalage nigra', 'Lesser Cuckooshrike; Lalage fimbriata', 'Mangrove Whistler; Pachycephala cinerea', 'Tiger Shrike; Lanius tigrinus', 'Brown Shrike; Lanius cristatus', 'Long-tailed Shrike; Lanius schach', 'White-bellied Erpornis; Erpornis zantholeuca', 'Black Drongo; Dicrurus macrocercus', 'Ashy Drongo; Dicrurus leucophaeus', 'Crow-billed Drongo; Dicrurus annectens', 'Hair-crested Drongo; Dicrurus hottentottus', 'Greater Racket-tailed Drongo; Dicrurus paradiseus', 'Malaysian Pied Fantail; Rhipidura javanica', 'Black-naped Monarch; Hypothymis azurea', 'Indian Paradise Flycatcher; Terpsiphone paradisi', "Blyth's Paradise Flycatcher; Terpsiphone affinis", 'Amur Paradise Flycatcher; Terpsiphone incei', 'Japanese Paradise Flycatcher; Terpsiphone atrocaudata', 'House Crow; Corvus splendens', 'Large-billed Crow; Corvus macrorhynchos', 'Japanese Tit; Parus minor', 'Eurasian Skylark; Alauda arvensis', 'Straw-headed Bulbul; Pycnonotus zeylanicus', 'Black-and-white Bulbul; Microtarsus melanoleucos', 'Black-headed Bulbul; Brachypodius melanocephalos', 'Black-crested Bulbul; Rubigula flaviventris', 'Red-whiskered Bulbul; Pycnonotus jocosus', 'Sooty-headed Bulbul; Pycnonotus aurigaster', 'Olive-winged Bulbul; Pycnonotus plumosus', 'Cream-vented Bulbul; Pycnonotus simplex', 'Asian Red-eyed Bulbul; Pycnonotus brunneus', 'Buff-vented Bulbul; Iole crypta', 'Streaked Bulbul; Ixos malaccensis', 'Cinereous Bulbul; Hemixos cinereus', 'Sand Martin; Riparia riparia', 'Pacific Swallow; Hirundo tahitica', 'Asian House Martin; Delichon dasypus', 'Red-rumped Swallow; Cecropis daurica', 'Yellow-browed Warbler; Phylloscopus inornatus', 'Dusky Warbler; Phylloscopus fuscatus', 'Eastern Crowned Warbler; Phylloscopus coronatus', 'Sakhalin Leaf Warbler; Phylloscopus borealoides', 'Arctic Warbler; Phylloscopus borealis', 'Oriental Reed Warbler; Acrocephalus orientalis', 'Black-browed Reed Warbler; Acrocephalus bistrigiceps', 'Booted Warbler; Iduna caligata', "Pallas's Grasshopper Warbler; Helopsaltes certhiola", 'Lanceolated Warbler; Locustella lanceolata', 'Zitting Cisticola; Cisticola juncidis', 'Yellow-bellied Prinia; Prinia flaviventris', 'Common Tailorbird; Orthotomus sutorius', 'Dark-necked Tailorbird; Orthotomus atrogularis', 'Rufous-tailed Tailorbird; Orthotomus sericeus', 'Ashy Tailorbird; Orthotomus ruficeps', 'Chestnut-winged Babbler; Cyanoderma erythropterum', 'Pin-striped Tit-babbler; Mixornis gularis', "Abbott's Babbler; Malacocincla abbotti", 'Moustached Babbler; Malacopteron magnirostre', 'Short-tailed Babbler; Pellorneum malaccense', 'White-chested Babbler; Pellorneum rostratum', 'White-crested Laughingthrush; Garrulax leucolophus', 'Chinese Hwamei; Garrulax canorus', "Swinhoe's White-eye; Zosterops simplex", 'Asian Fairy-bluebird; Irena puella', 'Velvet-fronted Nuthatch; Sitta frontalis', 'Common Hill Myna; Gracula religiosa', 'Crested Myna; Acridotheres cristatellus', 'Common Myna; Acridotheres tristis', 'Black-winged Starling; Acridotheres melanopterus', 'Red-billed Starling; Spodiopsar sericeus', 'White-cheeked Starling; Spodiopsar cineraceus', 'Daurian Starling; Agropsar sturninus', 'Chestnut-cheeked Starling; Agropsar philippensis', 'White-shouldered Starling; Sturnia sinensis', 'Brahminy Starling; Sturnia pagodarum', 'Rosy Starling; Pastor roseus', 'Orange-headed Thrush; Geokichla citrina', 'Siberian Thrush; Geokichla sibirica', 'Chinese Blackbird; Turdus mandarinus', 'Eyebrowed Thrush; Turdus obscurus', 'Oriental Magpie-Robin; Copsychus saularis', 'White-rumped Shama; Copsychus malabaricus', 'Grey-streaked Flycatcher; Muscicapa griseisticta', 'Dark-sided Flycatcher; Muscicapa sibirica', 'Asian Brown Flycatcher; Muscicapa dauurica', 'Brown-streaked Flycatcher; Muscicapa williamsoni', 'Ferruginous Flycatcher; Muscicapa ferruginea', 'Chinese Blue Flycatcher; Cyornis glaucicomans', 'Mangrove Blue Flycatcher; Cyornis rufigastra', 'Brown-chested Jungle Flycatcher; Cyornis brunneatus', 'Blue-and-white Flycatcher; Cyanoptila cyanomelana', "Zappey's Flycatcher; Cyanoptila cumatilis", 'Verditer Flycatcher; Eumyias thalassinus', 'Siberian Blue Robin; Larvivora cyane', 'Yellow-rumped Flycatcher; Ficedula zanthopygia', 'Narcissus Flycatcher; Ficedula narcissina', 'Green-backed Flycatcher; Ficedula elisae', 'Mugimaki Flycatcher; Ficedula mugimaki', 'Taiga Flycatcher; Ficedula albicilla', 'Daurian Redstart; Phoenicurus auroreus', 'Blue Rock Thrush; Monticola solitarius', 'White-throated Rock Thrush; Monticola gularis', "Stejneger's Stonechat; Saxicola stejnegeri", 'Greater Green Leafbird; Chloropsis sonnerati', 'Lesser Green Leafbird; Chloropsis cyanopogon', 'Blue-winged Leafbird; Chloropsis cochinchinensis', 'Scarlet-breasted Flowerpecker; Prionochilus thoracicus', 'Thick-billed Flowerpecker; Dicaeum agile', 'Yellow-vented Flowerpecker; Dicaeum chrysorrheum', 'Orange-bellied Flowerpecker; Dicaeum trigonostigma', 'Scarlet-backed Flowerpecker; Dicaeum cruentatum', 'Ruby-cheeked Sunbird; Chalcoparia singalensis', 'Brown-throated Sunbird; Anthreptes malacensis', "Van Hasselt's Sunbird; Leptocoma brasiliana", 'Copper-throated Sunbird; Leptocoma calcostetha', 'Olive-backed Sunbird; Cinnyris jugularis', 'Crimson Sunbird; Aethopyga siparaja', 'Little Spiderhunter; Arachnothera longirostra', 'Thick-billed Spiderhunter; Arachnothera crassirostris', 'Yellow-eared Spiderhunter; Arachnothera chrysogenys', 'House Sparrow; Passer domesticus', 'Eurasian Tree Sparrow; Passer montanus', 'Streaked Weaver; Ploceus manyar', 'Baya Weaver; Ploceus philippinus', 'Red Avadavat; Amandava amandava', 'White-rumped Munia; Lonchura striata', 'Javan Munia; Lonchura leucogastroides', 'Scaly-breasted Munia; Lonchura punctulata', 'Chestnut Munia; Lonchura atricapilla', 'White-headed Munia; Lonchura maja', 'Forest Wagtail; Dendronanthus indicus', 'Eastern Yellow Wagtail; Motacilla tschutschensis', 'Citrine Wagtail; Motacilla citreola', 'Grey Wagtail; Motacilla cinerea', 'White Wagtail; Motacilla alba', 'Paddyfield Pipit; Anthus rufulus', 'Olive-backed Pipit; Anthus hodgsoni', 'Red-throated Pipit; Anthus cervinus'];
  String url = "";
  CollectionReference _birdss =
  FirebaseFirestore.instance.collection('birds');

  // get key => null; // added this to fix button widget below

  @override
  void initState() {
    super.initState();

    NameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    NameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    child: Container(

      decoration: BoxDecoration(

        image: DecorationImage(

          fit:BoxFit.fill,
          image: AssetImage('assets/canva-photo-editor.png'),
          // image: AssetImage('assets/uploadbg1.png'),
          // image: AssetImage('assets/uploadbg2.png'),
        ),
      ),


      child: Center( child: ListView(
        padding: EdgeInsets.all(32),
        children: [
          IconButton(
            alignment: Alignment.topLeft,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 35.0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text("UPLOAD YOUR SIGHTING",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,

            ),  ),
          const SizedBox(height: 30),
          Container(
            color: Colors.white,
            child: DropdownSearch<String>(
              //mode of dropdown
              mode: Mode.DIALOG,
              //to show search box
              showSearchBox: true,
              showSelectedItems: true,
              //list of dropdown items
              items: ListOfBirds,
              // label: "Country",
              onChanged: print,
              //show selected item
              selectedItem: "Name of Bird Species",
            ),
          ),
          // buildEmail(),
          const SizedBox(height: 24),
          description(),
          const SizedBox(height: 24),
          // buildNumber(),
          // const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffFEAA9C),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,

                  ),
                ),
                onPressed:() async{
                  await uploadImage();
                  /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadImageDemo()),*/
                },
                icon: Icon(Icons.add_photo_alternate , size: 24),
                label: Text("Photo"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: position == null? Color(0xffFEAA9C): Color(0xff75E6E7),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed:() async{
                  var pos = await location.getLocation();
                  setState(() {
                    position = pos;
                  });
                  /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GeoListenPage()),
                      );*/
                },
                icon: position == null? Icon(Icons.add_location_alt_rounded, size: 24) : Icon(Icons.check_circle_outline_rounded, size: 24),
                label: position == null?  Text("Upload Location"): Text("Upload Success"),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ButtonWidget(
            text: 'Submit',
            onClicked: () async{
              final String? name = NameController.text;
              final String? description = DescriptionController.text;
              if (name != null && position != null && url != null){
                //var pos = await location.getLocation();
                await _birdss.add({"name": NameController.text, "timestamp": Timestamp.now(), "lat": position.latitude, 'lng': position.longitude, 'imgurl': url, 'description': description});
              }
              print('Email: ${NameController.text}');
              //print('Password: ${password}');
              print('Description: ${DescriptionController.text}');
            },
          ),
        ],
      ),
      ),
    ),
  );

  Widget buildEmail() => TextField(
    controller: NameController,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: const BorderSide(color: Colors.black38, width: 1.0),
      ),

      // hintText: 'name@example.com',
      labelText: 'Name of Bird Species',
      labelStyle: TextStyle(
        // fontWeight: FontWeight.bold,
          color: Color(0xffFEAA9C)),
      filled: true,
      fillColor: Colors.white,
      // prefixIcon: Icon(Icons.mail),
      // icon: Icon(Icons.mail),
      //  suffixIcon: emailController.text.isEmpty
      //    ? Container(width: 0)
      //     : IconButton(
      //        icon: Icon(Icons.close),
      //      onPressed: () => emailController.clear(),
      //   ),

      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.done,

  );
  // autofocus: true,


  Widget description() => TextField(
    controller: DescriptionController,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: const BorderSide(color: Colors.black38, width: 1.0),
      ),
      hintText: 'Example: Corner of Carpark C, on highest branch of tallest tree.',
      labelText: 'Specific Description of Location',
      labelStyle: TextStyle(
        // fontWeight: FontWeight.bold,
          color: Color(0xffFEAA9C)),
      filled: true,
      fillColor: Colors.white,
      // prefixIcon: Icon(Icons.mail),
      // icon: Icon(Icons.mail),
      //  suffixIcon: emailController.text.isEmpty
      //    ? Container(width: 0)
      //     : IconButton(
      //        icon: Icon(Icons.close),
      //      onPressed: () => emailController.clear(),
      //   ),
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.done,
    // autofocus: true,
  );

  /* Widget buildPassword() => TextField(
        onChanged: (value) => setState(() => this.password = value),
        onSubmitted: (value) => setState(() => this.password = value),
        decoration: InputDecoration(
          hintText: 'Your Password...',
          labelText: 'Password',
          errorText: 'Password is wrong',
          suffixIcon: IconButton(
            icon: isPasswordVisible
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            onPressed: () =>
                setState(() => isPasswordVisible = !isPasswordVisible),
          ),
          border: OutlineInputBorder(),
        ),
        obscureText: isPasswordVisible,
      ); */

  /* Widget buildNumber() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Number', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: numberController,
            decoration: InputDecoration(
              hintText: 'Enter number...',
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
          ),
        ],
      );*/
  uploadImage() async{
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();

    //Select Image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    if (image != null){
      var snapshot = await _storage.ref().child(image.name).putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        url = downloadUrl;
      });
    } else{
      print("NO IMAGE RECEIVED");
    }


    //Upload to Firebase
  }
}
