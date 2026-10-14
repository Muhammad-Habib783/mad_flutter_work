import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

// Colors (same teal scheme as login and profile)
const Color _primary = Color(0xFF00A8A8);
const Color _primaryLight = Color(0xFFE6F6F6);
const Color _textDark = Color(0xFF2C3E50);

// =====================================================================
// LANDING PAGE
// Shows every animation from Chapter 7 as a live demo:
//  1 AnimatedContainer   2 AnimatedCrossFade   3 AnimatedOpacity
//  4 AnimationController (2 controllers)   5 Staggered (1 controller)
// plus Tween, CurvedAnimation, Interval and AnimatedBuilder.
// Every demo plays by itself AND reacts to a tap.
// =====================================================================
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

// More than one AnimationController -> TickerProviderStateMixin (Chapter 7)
class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  // Values changed by setState (AnimatedOpacity / AnimatedContainer)
  double _opacity = 0.0;
  double _logoSize = 80.0;
  bool _line1 = false;
  bool _line2 = false;
  bool _line3 = false;
  bool _showCta = false;

  // Lets the user pause the demos (HCI: user control)
  final ValueNotifier<bool> _autoPlay = ValueNotifier<bool>(true);

  // Counts how many times the intro was started, so old timers are ignored
  int _run = 0;

  late AnimationController _intro; // long staggered timeline
  late AnimationController _float; // logo floats up and down
  late AnimationController _pulse; // ring inflates and deflates
  late Animation<double> _floatAnim;
  late Animation<double> _pulseAnim;

  late Animation<double> _labHeader;
  late List<Animation<double>> _demoAnims;
  late Animation<double> _summary;
  late List<Animation<double>> _chips;

  static const List<String> _concepts = <String>[
    'AnimatedContainer',
    'AnimatedCrossFade',
    'AnimatedOpacity',
    'AnimationController',
    'Tween',
    'CurvedAnimation',
    'Interval',
    'AnimatedBuilder',
  ];

  // One animation that runs only during part of the _intro timeline
  Animation<double> _interval(double begin, double end,
      [Curve curve = Curves.easeOutCubic]) {
    return CurvedAnimation(
      parent: _intro,
      curve: Interval(begin, end, curve: curve),
    );
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  // Creates every controller and animation. It is also called again by
  // reassemble(), so a normal hot reload no longer crashes the page.
  void _setup() {
    // 7 seconds so the whole entrance can be seen clearly
    _intro = AnimationController(
      duration: const Duration(milliseconds: 7000),
      vsync: this,
    );
    _float = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    );
    _pulse = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Tween -12 -> 12 = the logo floats up and down like the book balloon
    _floatAnim = Tween<double>(begin: -12.0, end: 12.0).animate(
      CurvedAnimation(parent: _float, curve: Curves.fastOutSlowIn),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.fastOutSlowIn),
    );

    // Staggered entrance: each part starts a little after the previous one
    _labHeader = _interval(0.00, 0.12);
    _demoAnims = <Animation<double>>[
      _interval(0.08, 0.26),
      _interval(0.20, 0.38),
      _interval(0.32, 0.50),
      _interval(0.44, 0.62),
      _interval(0.56, 0.74),
    ];
    _summary = _interval(0.64, 0.80);
    _chips = List<Animation<double>>.generate(_concepts.length, (i) {
      final double start = 0.70+i*0.02;
      return _interval(start, start+0.10, Curves.easeOutBack);
    });

    // When the long timeline ends, the Get Started button appears
    _intro.addStatusListener((status) {
      if (status==AnimationStatus.completed&&mounted) {
        setState(() => _showCta = true);
      }
    });

    _float.repeat(reverse: true);
    _pulse.repeat(reverse: true);

    _startTimeline();
  }

  // Hot reload keeps the old State object and does not call initState(),
  // so the new late fields would stay empty (the LateInitializationError).
  // reassemble() runs on every hot reload, so we rebuild everything here.
  @override
  void reassemble() {
    super.reassemble();
    _run++;
    // Old controllers may not exist (new field names), so ignore errors
    _safeDispose(() => _intro);
    _safeDispose(() => _float);
    _safeDispose(() => _pulse);
    _opacity = 0.0;
    _logoSize = 80.0;
    _line1 = false;
    _line2 = false;
    _line3 = false;
    _showCta = false;
    _setup();
  }

  void _safeDispose(AnimationController Function() getController) {
    try {
      getController().dispose();
    } catch (e) {
      // Controller was never created in the old version: nothing to dispose
    }
  }

  // Small helper: run code after a delay, only if this run is still current
  void _later(int ms, VoidCallback action) {
    final int run = _run;
    Future.delayed(Duration(milliseconds: ms), () {
      if (!mounted||run!=_run) return;
      action();
    });
  }

  void _startTimeline() {
    // Fade the whole card in after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _opacity = 1.0);
    });
    _later(300, () => setState(() => _logoSize = 120.0));
    _later(700, () => setState(() => _line1 = true));
    _later(1200, () => setState(() => _line2 = true));
    _later(1700, () => setState(() => _line3 = true));
    _later(1900, () => _intro.forward());
  }

  // Replay the intro from the start
  void _replay() {
    _run++;
    setState(() {
      _opacity = 0.0;
      _logoSize = 80.0;
      _line1 = false;
      _line2 = false;
      _line3 = false;
      _showCta = false;
    });
    _intro.reset();
    _startTimeline();
  }

  // User control: skip the intro (HCI)
  void _skipIntro() {
    _run++;
    setState(() {
      _opacity = 1.0;
      _logoSize = 120.0;
      _line1 = true;
      _line2 = true;
      _line3 = true;
      _showCta = true;
    });
    _intro.value = 1.0;
  }

  // Top Login button: opens the login form
  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Get Started: opens the register (sign up) page
  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _float.dispose();
    _pulse.dispose();
    _autoPlay.dispose();
    super.dispose();
  }

  // ---------- small animation helpers ----------

  // Fade + slide up (AnimatedBuilder)
  Widget _staggered(Animation<double> animation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0.0, 30.0*(1.0-animation.value)),
            child: child,
          ),
        );
      },
    );
  }

  // Fade + grow (used by the chips)
  Widget _pop(Animation<double> animation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.6+0.4*animation.value,
            child: child,
          ),
        );
      },
    );
  }

  // Text that fades in with AnimatedOpacity
  Widget _line(bool visible, Widget child) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeIn,
      child: child,
    );
  }

  // Floating logo: Tween float + pulsing ring + AnimatedContainer growth
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, _floatAnim.value),
          child: child,
        );
      },
      child: SizedBox(
        width: 160.0,
        height: 160.0,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ScaleTransition(
              scale: _pulseAnim,
              child: Container(
                width: 130.0,
                height: 130.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _primary.withOpacity(0.35), width: 3.0),
                ),
              ),
            ),
            Semantics(
              label: 'App logo',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutBack,
                width: _logoSize,
                height: _logoSize,
                decoration: BoxDecoration(
                  color: _primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: _primary, width: 3.0),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.25),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 8.0),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.flutter_dash,
                  size: _logoSize*0.6,
                  color: _primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Progress bar + Skip  ->  Get Started (AnimatedCrossFade)
  Widget _buildCta() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 900),
      firstCurve: Curves.easeOut,
      secondCurve: Curves.easeIn,
      sizeCurve: Curves.easeOutCubic,
      crossFadeState:
      _showCta ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const Text(
              'Getting things ready...',
              style: TextStyle(fontSize: 14.0, color: Colors.black54),
            ),
            const SizedBox(height: 12.0),
            AnimatedBuilder(
              animation: _intro,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: LinearProgressIndicator(
                    value: _intro.value,
                    minHeight: 6.0,
                    color: _primary,
                    backgroundColor: _primaryLight,
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: _skipIntro,
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            ),
          ],
        ),
      ),
      secondChild: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const Text(
              'Ready to explore?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 6.0),
            const Text(
              'Create an account to view my full profile.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, color: Colors.black54),
            ),
            const SizedBox(height: 18.0),
            // The button gently pulses (Tween + controller)
            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.03).animate(_pulse),
              child: SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: _goToRegister,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _replay,
              icon: const Icon(Icons.replay, size: 18.0, color: _primary),
              label: const Text(
                'Replay intro',
                style: TextStyle(color: _primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Title + auto-play switch above the demos
  Widget _buildLabHeader() {
    return Column(
      children: <Widget>[
        const Text(
          'ANIMATION LAB',
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: _primary,
          ),
        ),
        const SizedBox(height: 6.0),
        const Text(
          'Chapter 7: Adding Animation to an App',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 6.0),
        const Text(
          'Every demo plays by itself. Tap any of them to trigger it yourself.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        const SizedBox(height: 8.0),
        ValueListenableBuilder<bool>(
          valueListenable: _autoPlay,
          builder: (context, value, child) {
            // Pill with a border and background, so it stays visible
            // in both states (ON and OFF) even when the cursor leaves
            return Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.only(left: 16.0, right: 6.0),
                decoration: BoxDecoration(
                  color: value ? _primaryLight : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: value ? _primary : Colors.grey.shade500,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      value ? 'Auto-play: ON' : 'Auto-play: OFF',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Switch(
                      value: value,
                      activeColor: Colors.white,
                      activeTrackColor: _primary,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade500,
                      onChanged: (v) => _autoPlay.value = v,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Card that lists everything that was used
  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _primaryLight,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Used on this page',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Too many animations hurt the UX, so each one here shows a real action.',
            style: TextStyle(fontSize: 13.0, color: Colors.black54),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List<Widget>.generate(
              _concepts.length,
                  (i) => _pop(_chips[i], _Chip(label: _concepts[i])),
            ),
          ),
        ],
      ),
    );
  }

  // Soft floating circles behind the card
  Widget _bubble(double size, Alignment alignment, double shift, double alpha) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: _floatAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0.0, _floatAnim.value*shift),
            child: child,
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _primary.withOpacity(alpha),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth =
    screenWidth<700 ? screenWidth : (screenWidth*0.4).clamp(460.0, 800.0);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          IgnorePointer(
            child: Stack(
              children: <Widget>[
                _bubble(220.0, const Alignment(-1.1, -0.9), 3.0, 0.10),
                _bubble(160.0, const Alignment(1.1, -0.3), -2.5, 0.08),
                _bubble(260.0, const Alignment(0.9, 1.1), 2.0, 0.10),
                _bubble(120.0, const Alignment(-0.9, 0.7), -3.0, 0.07),
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: ScrollConfiguration(
                behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: cardWidth),
                      // AnimatedOpacity: the whole card fades in
                      child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeIn,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 20.0,
                                offset: const Offset(0.0, 10.0),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // ---------- LOGIN BUTTON (inside the card corner) ----------
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: _primary,
                                    side: const BorderSide(
                                        color: _primary, width: 1.5),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 12.0),
                                  ),
                                  onPressed: _goToLogin,
                                  icon: const Icon(Icons.login, size: 18.0),
                                  label: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              // ---------- HERO ----------
                              _buildLogo(),
                              const SizedBox(height: 8.0),
                              _line(
                                _line1,
                                const Text(
                                  'WELCOME TO MY APP',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0,
                                    color: _primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              _line(
                                _line2,
                                const Text(
                                  'Muhammad Habib',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: _textDark,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              _line(
                                _line3,
                                const Text(
                                  'Software Engineering Student | Flutter Developer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22.0),

                              // Progress -> Get Started (AnimatedCrossFade)
                              _buildCta(),
                              const SizedBox(height: 28.0),

                              // ---------- ANIMATION LAB ----------
                              _staggered(_labHeader, _buildLabHeader()),
                              const SizedBox(height: 16.0),

                              _staggered(
                                _demoAnims[0],
                                _DemoCard(
                                  number: 1,
                                  title: 'AnimatedContainer',
                                  code: 'duration 500ms  |  Curves.elasticOut',
                                  description:
                                  'The width grows by 50 on each tap and '
                                      'resets to 100. elasticOut gives the spring.',
                                  child: AnimatedContainerDemo(
                                      autoPlay: _autoPlay),
                                ),
                              ),
                              _staggered(
                                _demoAnims[1],
                                _DemoCard(
                                  number: 2,
                                  title: 'AnimatedCrossFade',
                                  code: 'duration 500ms  |  sizeCurve bounceOut',
                                  description:
                                  'Colour (amber to lime) and size (100 to 200) '
                                      'change at the same time.',
                                  child: CrossFadeDemo(autoPlay: _autoPlay),
                                ),
                              ),
                              _staggered(
                                _demoAnims[2],
                                _DemoCard(
                                  number: 3,
                                  title: 'AnimatedOpacity',
                                  code: 'duration 500ms  |  opacity 1.0 <-> 0.3',
                                  description:
                                  'The box fades out and back in smoothly '
                                      'over half a second.',
                                  child: OpacityDemo(autoPlay: _autoPlay),
                                ),
                              ),
                              _staggered(
                                _demoAnims[3],
                                _DemoCard(
                                  number: 4,
                                  title: 'AnimationController (2 controllers)',
                                  code: 'TickerProviderStateMixin  |  Tween  |  '
                                      'CurvedAnimation  |  AnimatedBuilder',
                                  description:
                                  'Controller 1 floats the balloon up (4 s, '
                                      'fastOutSlowIn). Controller 2 inflates it '
                                      '(2 s, elasticInOut). Tap to reverse.',
                                  child: BalloonDemo(autoPlay: _autoPlay),
                                ),
                              ),
                              _staggered(
                                _demoAnims[4],
                                _DemoCard(
                                  number: 5,
                                  title: 'Staggered animation (1 controller)',
                                  code: 'SingleTickerProviderStateMixin  |  '
                                      'Interval(begin, end)',
                                  description:
                                  'One 4 s controller. Inflate runs from 0.0 to '
                                      '0.5 and float runs from 0.0 to 1.0. Watch '
                                      'the timeline bars fill.',
                                  child: StaggeredBalloonDemo(
                                      autoPlay: _autoPlay),
                                ),
                              ),
                              const SizedBox(height: 4.0),

                              _staggered(_summary, _buildSummary()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SMALL REUSABLE WIDGETS
// =====================================================================

// Card around one demo: number, title, code line, description, demo
class _DemoCard extends StatelessWidget {
  final int number;
  final String title;
  final String code;
  final String description;
  final Widget child;

  const _DemoCard({
    required this.number,
    required this.title,
    required this.code,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 28.0,
                height: 28.0,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: _primaryLight,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: _primary,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: const TextStyle(
                fontSize: 13.0, height: 1.4, color: Colors.black54),
          ),
          const SizedBox(height: 14.0),
          child,
        ],
      ),
    );
  }
}

// Rounded tag (same look as the profile skill chips)
class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: _primary.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          color: _primary,
        ),
      ),
    );
  }
}

// Small teal status text shown under each demo
class _Status extends StatelessWidget {
  final String text;

  const _Status(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          color: _primary,
        ),
      ),
    );
  }
}

// Balloon drawn with widgets (no image needed)
Widget _balloonShape(double width, Color color) {
  final double w = width<0.0 ? 0.0 : width;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ClipOval(
        child: Container(
          width: w,
          height: w*1.2,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.3, -0.4),
              radius: 0.9,
              colors: <Color>[Colors.white.withOpacity(0.85), color],
            ),
          ),
        ),
      ),
      // Knot
      Transform.rotate(
        angle: 0.785,
        child: Container(width: 8.0, height: 8.0, color: color),
      ),
      // String
      Container(width: 1.5, height: 30.0, color: Colors.grey),
    ],
  );
}

// =====================================================================
// DEMO 1: AnimatedContainer (book code, same idea)
// =====================================================================
class AnimatedContainerDemo extends StatefulWidget {
  final ValueNotifier<bool> autoPlay;

  const AnimatedContainerDemo({super.key, required this.autoPlay});

  @override
  State<AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  final double _height = 100.0;
  double _width = 100.0;
  double _maxWidth = 320.0;
  Timer? _timer;

  // Grow by 50, go back to 100 when the next step would be too wide
  void _increaseWidth() {
    setState(() {
      _width = _width+50.0>_maxWidth ? 100.0 : _width+50.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1800), (t) {
      if (!mounted||!widget.autoPlay.value) return;
      _increaseWidth();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxWidth = constraints.maxWidth;
        return Column(
          children: <Widget>[
            SizedBox(
              height: _height,
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  height: _height,
                  width: _width,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: _textDark,
                    ),
                    onPressed: _increaseWidth,
                    child: Text(
                      'Tap to\nGrow Width\n${_width.round()}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            _Status('width: ${_width.round()}'),
          ],
        );
      },
    );
  }
}

// =====================================================================
// DEMO 2: AnimatedCrossFade (book code, same idea)
// =====================================================================
class CrossFadeDemo extends StatefulWidget {
  final ValueNotifier<bool> autoPlay;

  const CrossFadeDemo({super.key, required this.autoPlay});

  @override
  State<CrossFadeDemo> createState() => _CrossFadeDemoState();
}

class _CrossFadeDemoState extends State<CrossFadeDemo> {
  bool _crossFadeStateShowFirst = true;
  Timer? _timer;

  void _crossFade() {
    setState(() {
      _crossFadeStateShowFirst = !_crossFadeStateShowFirst;
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2200), (t) {
      if (!mounted||!widget.autoPlay.value) return;
      _crossFade();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Fixed height so the page does not jump when the size changes
        SizedBox(
          height: 200.0,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 500),
                  sizeCurve: Curves.bounceOut,
                  crossFadeState: _crossFadeStateShowFirst
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    height: 100.0,
                    width: 100.0,
                  ),
                  secondChild: Container(
                    decoration: BoxDecoration(
                      color: Colors.lime,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
                // Button over the animation gives it a label and a tap
                Positioned.fill(
                  child: TextButton(
                    style: TextButton.styleFrom(foregroundColor: _textDark),
                    onPressed: _crossFade,
                    child: const Text(
                      'Tap to\nFade Color & Size',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _Status(_crossFadeStateShowFirst
            ? 'crossFadeState: showFirst'
            : 'crossFadeState: showSecond'),
      ],
    );
  }
}

// =====================================================================
// DEMO 3: AnimatedOpacity (book code, same idea)
// =====================================================================
class OpacityDemo extends StatefulWidget {
  final ValueNotifier<bool> autoPlay;

  const OpacityDemo({super.key, required this.autoPlay});

  @override
  State<OpacityDemo> createState() => _OpacityDemoState();
}

class _OpacityDemoState extends State<OpacityDemo> {
  double _opacity = 1.0;
  Timer? _timer;

  void _animatedOpacity() {
    setState(() {
      _opacity = _opacity==1.0 ? 0.3 : 1.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1600), (t) {
      if (!mounted||!widget.autoPlay.value) return;
      _animatedOpacity();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100.0,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _opacity,
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: _textDark),
                  onPressed: _animatedOpacity,
                  child: const Text('Tap to\nFade', textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ),
        _Status('opacity: $_opacity'),
      ],
    );
  }
}

// =====================================================================
// DEMO 4: AnimationController, TWO controllers (book balloon)
// One floats the balloon, the other inflates it.
// =====================================================================
class BalloonDemo extends StatefulWidget {
  final ValueNotifier<bool> autoPlay;

  const BalloonDemo({super.key, required this.autoPlay});

  @override
  State<BalloonDemo> createState() => _BalloonDemoState();
}

class _BalloonDemoState extends State<BalloonDemo>
    with TickerProviderStateMixin {
  static const double _stageHeight = 260.0;
  static const double _balloonWidth = 110.0;

  late AnimationController _controllerFloatUp;
  late AnimationController _controllerGrowSize;
  late Animation<double> _animationFloatUp;
  late Animation<double> _animationGrowSize;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controllerFloatUp = AnimationController(
        duration: const Duration(seconds: 4), vsync: this);
    _controllerGrowSize = AnimationController(
        duration: const Duration(seconds: 2), vsync: this);

    // Float: from the bottom of the stage (160) to the top (0.0)
    _animationFloatUp = Tween<double>(begin: _stageHeight-100.0, end: 0.0)
        .animate(CurvedAnimation(
        parent: _controllerFloatUp, curve: Curves.fastOutSlowIn));
    // Inflate: from 50.0 to the full balloon width, with a spring
    _animationGrowSize = Tween<double>(begin: 50.0, end: _balloonWidth)
        .animate(CurvedAnimation(
        parent: _controllerGrowSize, curve: Curves.elasticInOut));

    // Start by itself shortly after the page opens
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _controllerFloatUp.forward();
      _controllerGrowSize.forward();
    });

    // Auto-play: reverse / forward again when an animation has finished
    _timer = Timer.periodic(const Duration(seconds: 6), (t) {
      if (!mounted||!widget.autoPlay.value) return;
      if (_controllerFloatUp.isCompleted) {
        _controllerFloatUp.reverse();
        _controllerGrowSize.reverse();
      } else if (_controllerFloatUp.isDismissed) {
        _controllerFloatUp.forward();
        _controllerGrowSize.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controllerFloatUp.dispose();
    _controllerGrowSize.dispose();
    super.dispose();
  }

  // Same logic as the book's onTap
  void _onTap() {
    if (_controllerFloatUp.isCompleted) {
      _controllerFloatUp.reverse();
      _controllerGrowSize.reverse();
    } else {
      _controllerFloatUp.forward();
      _controllerGrowSize.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: _stageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _primaryLight,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    <Listenable>[_animationFloatUp, _animationGrowSize]),
                builder: (context, child) {
                  final double top = _animationFloatUp.value<0.0
                      ? 0.0
                      : _animationFloatUp.value;
                  return Container(
                    margin: EdgeInsets.only(top: top),
                    child: GestureDetector(
                      onTap: _onTap,
                      child: _balloonShape(
                          _animationGrowSize.value, _primary),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controllerFloatUp,
          builder: (context, child) {
            return _Status(
                'float: ${_controllerFloatUp.value.toStringAsFixed(2)}   |   '
                    'inflate: ${_controllerGrowSize.value.toStringAsFixed(2)}');
          },
        ),
      ],
    );
  }
}

// =====================================================================
// DEMO 5: Staggered animation, ONE controller + Interval (book)
// =====================================================================
class StaggeredBalloonDemo extends StatefulWidget {
  final ValueNotifier<bool> autoPlay;

  const StaggeredBalloonDemo({super.key, required this.autoPlay});

  @override
  State<StaggeredBalloonDemo> createState() => _StaggeredBalloonDemoState();
}

class _StaggeredBalloonDemoState extends State<StaggeredBalloonDemo>
    with SingleTickerProviderStateMixin {
  static const double _stageHeight = 260.0;
  static const double _balloonWidth = 110.0;

  late AnimationController _controller;
  late Animation<double> _animationFloatUp;
  late Animation<double> _animationGrowSize;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(seconds: 4), vsync: this);

    // Float runs during the whole timeline: Interval(0.0, 1.0)
    _animationFloatUp = Tween<double>(begin: _stageHeight-100.0, end: 0.0)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
    ));
    // Inflate only runs in the first half: Interval(0.0, 0.5)
    _animationGrowSize = Tween<double>(begin: 50.0, end: _balloonWidth)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticInOut),
    ));

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _controller.forward();
    });

    _timer = Timer.periodic(const Duration(seconds: 6), (t) {
      if (!mounted||!widget.autoPlay.value) return;
      if (_controller.isCompleted) {
        _controller.reverse();
      } else if (_controller.isDismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  // Timeline bar: shows where an Interval starts and ends, and fills up
  Widget _bar(String label, double begin, double end) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label   Interval($begin, $end)',
            style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: _textDark),
          ),
          const SizedBox(height: 4.0),
          SizedBox(
            height: 10.0,
            child: LayoutBuilder(
              builder: (context, c) {
                final double w = c.maxWidth;
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final double fill =
                    ((_controller.value-begin)/(end-begin))
                        .clamp(0.0, 1.0);
                    return Stack(
                      children: <Widget>[
                        // Whole timeline (0.0 to 1.0)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        // This animation's slot on the timeline
                        Positioned(
                          left: w*begin,
                          width: w*(end-begin),
                          top: 0.0,
                          bottom: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _primary.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: fill,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _primary,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: _stageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _primaryLight,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    <Listenable>[_animationFloatUp, _animationGrowSize]),
                builder: (context, child) {
                  final double top = _animationFloatUp.value<0.0
                      ? 0.0
                      : _animationFloatUp.value;
                  return Container(
                    margin: EdgeInsets.only(top: top),
                    child: GestureDetector(
                      onTap: _onTap,
                      child: _balloonShape(
                          _animationGrowSize.value, Colors.amber),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        _bar('Inflate', 0.0, 0.5),
        _bar('Float', 0.0, 1.0),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return _Status(
                'controller value: ${_controller.value.toStringAsFixed(2)}');
          },
        ),
      ],
    );
  }
}