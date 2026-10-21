import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Home screen of an app built with the Spectrum components.
class HomeScreenTemplate extends StatelessWidget {
  const HomeScreenTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 16),
        forceMaterialTransparency: true,
        // The logo is a plain Image, since SpectrumImage paints its gray
        // placeholder behind transparent images and the logo has no background.
        title: Image.network("https://cdn-icons-png.flaticon.com/512/8564/8564441.png", width: 32, height: 32),
        leading: Center(
          child: SpectrumActionButtonGroup(
            isQuiet: true,
            children: [SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.realTimeCustomerProfile, size: 18))],
          ),
        ),
        actions: [
          SpectrumActionButtonGroup(
            isQuiet: true,
            children: [SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.chat, size: 18))],
          ),
        ],
      ),
      // The floating button stretches between the 16px page margins and
      // stays above the bottom navigation while the page scrolls under it.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: SpectrumButton(content: "Novo Projeto", variant: SpectrumButtonVariant.accent, onTap: () {}),
        ),
      ),
      // Spectrum has no bottom navigation, so the Material one is used with the
      // primary color on the current tab. The fixed type keeps the 5 labels visible.
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        // The same size on both states keeps the current label from growing.
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        items: [
          BottomNavigationBarItem(icon: SpectrumIcon(SpectrumIcons.home, size: 18), label: "Início"),
          BottomNavigationBarItem(icon: SpectrumIcon(SpectrumIcons.folderOutline, size: 18), label: "Projetos"),
          BottomNavigationBarItem(icon: SpectrumIcon(SpectrumIcons.colorPalette, size: 18), label: "Studio"),
          BottomNavigationBarItem(icon: SpectrumIcon(SpectrumIcons.artboard, size: 18), label: "Modelos"),
          BottomNavigationBarItem(icon: SpectrumIcon(SpectrumIcons.settings, size: 18), label: "Configurações"),
        ],
      ),
      // The whole page scrolls as a single list, so no section needs
      // a bounded height of its own, like an Expanded, to scroll.
      body: ListView(
        // The larger bottom padding lets the last projects scroll above the floating button.
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
        children: [
          SpectrumSearchField(placeholder: "Buscar projetos e arquivos"),
          const _SectionHeader(title: "Projetos Recentes"),
          const _CardCarousel(firstSeed: 1),
          const _SectionHeader(title: "Arquivos em Nuvem"),
          const _FileList(),
          const _SectionHeader(title: "Em Alta"),
          const _ProjectGrid(firstSeed: 11),
        ],
      ),
    );
  }
}

/// Title of a home section, with a chevron that opens the full list.
class _SectionHeader extends StatelessWidget {
  /// Text of the section title.
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    // The vertical padding separates the sections, since the ListView
    // has no spacing between its children.
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
          SpectrumActionButton(isQuiet: true, icon: SpectrumIcon(SpectrumIcons.chevronRight, size: 18)),
        ],
      ),
    );
  }
}

/// Row of 10 project cards that scrolls sideways.
class _CardCarousel extends StatelessWidget {
  /// Seed of the first placeholder image, increased by one for each card.
  final int firstSeed;

  const _CardCarousel({required this.firstSeed});

  @override
  Widget build(BuildContext context) {
    // The coordinator reveals all the card images together, once they have loaded,
    // so the row does not show them popping in one by one.
    return SpectrumImageCoordinator(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 16,
          children: List.generate(10, (int index) {
            return SpectrumCard(
              title: Text("Lorem ipsum dolor"),
              description: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
              preview: SpectrumCardPreview(
                aspectRatio: 3,
                // The preview wraps the image in a FittedBox, which needs a finite size
                // to scale from, so the image gets its real 800x600 size.
                child: SpectrumImage(
                  uri: Uri.parse("https://picsum.photos/seed/${firstSeed + index}/800/600"),
                  width: 800,
                  height: 600,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// List of the 3 latest cloud files, each with a document icon on the left.
class _FileList extends StatelessWidget {
  const _FileList();

  @override
  Widget build(BuildContext context) {
    // Only the 3 latest files are shown, without a scroll inside the page scroll,
    // since the section header chevron opens the full list.
    return SpectrumListView(
      children: List.generate(3, (int index) {
        return SpectrumListViewItem(
          icon: SpectrumIcon(SpectrumIcons.document),
          description: Text("Lorem ipsum dolor sit amet"),
          actions: SpectrumActionButton(isQuiet: true, icon: SpectrumIcon(SpectrumIcons.download)),
          child: Text("Arquivo ${index + 1}"),
        );
      }),
    );
  }
}

/// Grid of 4 trending projects in two columns, each an image with its title and description below.
class _ProjectGrid extends StatelessWidget {
  /// Seed of the first placeholder image, increased by one for each project.
  final int firstSeed;

  const _ProjectGrid({required this.firstSeed});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    // The coordinator reveals all the grid images together, once they have loaded.
    // shrinkWrap and the disabled physics make the grid as tall as its items,
    // so it scrolls togethers with the page instead of having a scroll of its own.
    return SpectrumImageCoordinator(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(4, (int index) {
          return Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The 4:3 ratio gives the image its height, since its width
              // comes from the grid column.
              AspectRatio(
                aspectRatio: 4 / 3,
                child: SpectrumImage(
                  uri: Uri.parse("https://picsum.photos/seed/${firstSeed + index}/800/600"),
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Text("Lorem ipsum dolor", style: text.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                style: text.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        }),
      ),
    );
  }
}

bool _IsFramedKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isFramed',
    options: [true, false],
    initialOption: true,
    description: 'Whether the screen is shown inside an iPhone frame.',
  );
}

@widgetbook.UseCase(name: 'Presentation', type: HomeScreenTemplate, path: '[Templates]')
Widget buildHomeScreenPresentation(BuildContext context) {
  final Widget screen;

  if (_IsFramedKnobsFn(context)) {
    // When isFramed is True, the screen is drawn inside an iPhone 13,
    // which previews the mobile layout on a desktop Widgetbook.
    screen = DeviceFrame(device: Devices.ios.iPhone13, screen: const HomeScreenTemplate());
  } else {
    // When isFramed is False, the screen fills the canvas as it is,
    // which is how it looks when the Widgetbook runs on a phone.
    screen = const HomeScreenTemplate();
  }

  return screen;
}
