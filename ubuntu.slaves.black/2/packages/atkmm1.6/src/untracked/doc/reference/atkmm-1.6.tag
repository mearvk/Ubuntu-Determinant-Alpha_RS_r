<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile>
  <compound kind="class">
    <name>Atk::Action</name>
    <filename>classAtk_1_1Action.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Action</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a87a439e94f0fa5e4b0d415c2fd74399c</anchor>
      <arglist>(Action &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Action &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>ac4934552741da09f0ca2a0d97901e5b7</anchor>
      <arglist>(Action &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Action</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>aa349416302cf9826f2f5e017cb29b67f</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkAction *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a922d5d2a5c8af62cdea07810b229094e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkAction *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a2372fab551e83919d6d55010f881044f</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>do_action</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a41aa7ecc13346d8f9a826d9d9cf88a57</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_actions</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>aa698f3d737de395afd3759c850cebba1</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_description</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a57dc505bf074239c89b31681e957ab83</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_name</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>ae8bb8b740952594f5169b983a45e2b23</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_keybinding</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a4acdb52d10250f647be0c063cf21293f</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_description</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>af157b00d0904b8dfde07048ec7980c77</anchor>
      <arglist>(int i, const Glib::ustring &amp;desc)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_localized_name</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a346497af2820bd9d0db1c2944ac779cf</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a2e7470667a8a5a98a1a199111e80bc35</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a02c3cea2ff08a6c1eeeedef35af32513</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Action</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>ac4e11558ec7198e7b57f6866cd7a750b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>do_action_vfunc</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a13d4c4e640ce5583e806f0d9dcefd437</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_n_actions_vfunc</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>af62a12308bdef0811e6daced29ec85cc</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const char *</type>
      <name>get_description_vfunc</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>ad025cc8f644426200894f062d2db1573</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const char *</type>
      <name>get_name_vfunc</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a41e3d9bc5fcef177a26fe131cf04b49e</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const char *</type>
      <name>get_keybinding_vfunc</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a27f7a9d1dcab566b8c9a2cd3f8ef5cc6</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_description_vfunc</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a94c613c958a84eac9610ca84bc78d0be</anchor>
      <arglist>(int i, const Glib::ustring &amp;desc)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Action &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Action.html</anchorfile>
      <anchor>a7fec8f013e04cd52a8bb16a68ce3b6ff</anchor>
      <arglist>(AtkAction *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Attribute</name>
    <filename>classAtk_1_1Attribute.html</filename>
    <member kind="function">
      <type></type>
      <name>Attribute</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>a043d21fa0123a7152130da5cb85cd12a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Attribute</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>ac46e36dcd3292d21fd29139ba4db127c</anchor>
      <arglist>(const Glib::ustring &amp;name, const Glib::ustring &amp;value)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Attribute</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>a3edce1f392cd9e725dc6cca8a66866ca</anchor>
      <arglist>(const AtkAttribute *gobject)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Attribute</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>ab4f0cb246a8c72bb2cabf6b79c0ef267</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Attribute</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>a353ff05cceb0726cfab495f389a6426c</anchor>
      <arglist>(const Attribute &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>Attribute &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>adeceb8f108e73ef214843ccb3e715575</anchor>
      <arglist>(const Attribute &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>swap</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>a64230b500df68f2a178755a74ca1f77f</anchor>
      <arglist>(Attribute &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_name</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>ae791fabdee640e4d0c0edf5a326fdee6</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_value</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>acc9264b10739d04fd1fb099fc6347cd9</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkAttribute *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>a50ba5d3fa3ba931a1301edb43d42028d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkAttribute *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>a5ffd66a3f75c573f0fed5a7d4ee42218</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="variable" protection="protected">
      <type>AtkAttribute</type>
      <name>gobject_</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>a8243e2df2dea5d0d6e54ea5f0a645879</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>swap</name>
      <anchorfile>classAtk_1_1Attribute.html</anchorfile>
      <anchor>ab160a8d72a859ee7b7b9eb83da3c9ef3</anchor>
      <arglist>(Attribute &amp;lhs, Attribute &amp;rhs)</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>Atk::AttributeTraits</name>
    <filename>structAtk_1_1AttributeTraits.html</filename>
    <member kind="typedef">
      <type>Atk::Attribute</type>
      <name>CppType</name>
      <anchorfile>structAtk_1_1AttributeTraits.html</anchorfile>
      <anchor>ad1880881d4bb61879592a79116f49a2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>const AtkAttribute *</type>
      <name>CType</name>
      <anchorfile>structAtk_1_1AttributeTraits.html</anchorfile>
      <anchor>afdc02e4c19a2cbb12d2104ead4cece4b</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>AtkAttribute *</type>
      <name>CTypeNonConst</name>
      <anchorfile>structAtk_1_1AttributeTraits.html</anchorfile>
      <anchor>a37462f65af25780b9a555588af344053</anchor>
      <arglist></arglist>
    </member>
    <member kind="function" static="yes">
      <type>static CType</type>
      <name>to_c_type</name>
      <anchorfile>structAtk_1_1AttributeTraits.html</anchorfile>
      <anchor>a56d6bf64e4c1cebd6637046a635de36f</anchor>
      <arglist>(CType item)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static CType</type>
      <name>to_c_type</name>
      <anchorfile>structAtk_1_1AttributeTraits.html</anchorfile>
      <anchor>af460000f0f606f11d05f5db4d6a45425</anchor>
      <arglist>(const CppType &amp;item)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static CppType</type>
      <name>to_cpp_type</name>
      <anchorfile>structAtk_1_1AttributeTraits.html</anchorfile>
      <anchor>a8463fe4d8ecb2f3d76b7fc63b4ad1e27</anchor>
      <arglist>(CType item)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>release_c_type</name>
      <anchorfile>structAtk_1_1AttributeTraits.html</anchorfile>
      <anchor>a8886ec0bad433b3db10a9d1a06c009c8</anchor>
      <arglist>(CType item)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Component</name>
    <filename>classAtk_1_1Component.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Component</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a73bf5cdf33a1d8bb907d130645749f40</anchor>
      <arglist>(Component &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Component &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a572edbd3cf1744c51b1cef085c51b28c</anchor>
      <arglist>(Component &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Component</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>aa50ff95a626dc9e5dc5325c44a32e19a</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkComponent *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a4e9352cd6e5e139cd5b5c310fab5d993</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkComponent *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>acca597d13f18df1b507a739f245a402a</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>guint</type>
      <name>add_focus_handler</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a3801c9c8883b04c3cb6cbc3a8324d720</anchor>
      <arglist>(AtkFocusHandler handler)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>contains</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>adfdd4667a6179c84f49a28bf7b2c3b6c</anchor>
      <arglist>(int x, int y, CoordType coord_type) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_accessible_at_point</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a587373de988a993ac69473a6f968d592</anchor>
      <arglist>(int x, int y, CoordType coord_type)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_extents</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>aff54a73d11808f3b83e476b0b6c6ef72</anchor>
      <arglist>(int &amp;x, int &amp;y, int &amp;width, int &amp;height, CoordType coord_type) const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_position</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>ab3f0b95a127bd1007bc90bf8c34077ba</anchor>
      <arglist>(int &amp;x, int &amp;y, CoordType coord_type) const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_size</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a5a99521eb20cd82226016196f642684b</anchor>
      <arglist>(int &amp;width, int &amp;height) const </arglist>
    </member>
    <member kind="function">
      <type>Layer</type>
      <name>get_layer</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a24ae6220ea9146327965cc116ec5b486</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_mdi_zorder</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a2ce831669dc8644aa58c0e1540f78bf7</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>grab_focus</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>ab62940b0782345103171b8e752b58f28</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>remove_focus_handler</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a980a75536f126672470779ab68a08502</anchor>
      <arglist>(guint handler_id)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_extents</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a9d4d0aa5f9531ed200340e4b273c29cd</anchor>
      <arglist>(int x, int y, int width, int height, CoordType coord_type)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_position</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a0f799ad812be9ee955d5e04b1022d107</anchor>
      <arglist>(int x, int y, CoordType coord_type)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_size</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a41f4181b9b75198b77e2edbdb5dab2f2</anchor>
      <arglist>(int width, int height)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a15771f86615e09fff9cc8a2e2edabf47</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>aed84d91484c71856c5f082bf0a1a817b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Component</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>af1afe43507f5afcf2f996cc847d7c084</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual guint</type>
      <name>add_focus_handler_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a93b433cd08ca6b758ff4b322974b9ed7</anchor>
      <arglist>(AtkFocusHandler handler)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>contains_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>af0091566b6e9eb55c6dac5cb67d587e0</anchor>
      <arglist>(int x, int y, CoordType coord_type) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_accessible_at_point_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a7d342091a622e3396135beba74423ae2</anchor>
      <arglist>(int x, int y, CoordType coord_type)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_extents_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a4d857e04a0a423823e0d59d411bdb24d</anchor>
      <arglist>(int &amp;x, int &amp;y, int &amp;width, int &amp;height, CoordType coord_type) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_position_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a085db135f48e8e47385276b9a60c3395</anchor>
      <arglist>(int &amp;x, int &amp;y, CoordType coord_type) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_size_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a5a5778183be0193e7da814c21e8ef79d</anchor>
      <arglist>(int &amp;width, int &amp;height) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Layer</type>
      <name>get_layer_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a82df7736bc5d929450ffe75f209a14fa</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_mdi_zorder_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>af25995d80bbe33242cd4a2dff11b6764</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>grab_focus_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a1b44688c98c64438910d4aa526b9c7a6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>remove_focus_handler_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a2364cc6e09512e0f3fdbc296789da99e</anchor>
      <arglist>(guint handler_id)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_extents_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a035a8abcdf88833c8343ef73a2d42396</anchor>
      <arglist>(int x, int y, int width, int height, CoordType coord_type)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_position_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a46471481ae0d6e3554d45d1ef6563cd0</anchor>
      <arglist>(int x, int y, CoordType coord_type)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_size_vfunc</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>af1ffcb3ec49ce31a9a102757dfd4a2b7</anchor>
      <arglist>(int width, int height)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Component &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Component.html</anchorfile>
      <anchor>a3eb83954385bb8705cfd2d6d4f2a0f23</anchor>
      <arglist>(AtkComponent *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Document</name>
    <filename>classAtk_1_1Document.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Document</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a1975a281a46f8531334e06a14411eec1</anchor>
      <arglist>(Document &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Document &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>ade3d17611781ea669d5b0d9fbe353aed</anchor>
      <arglist>(Document &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Document</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>ab22eab361226e46c4f16fc636eb0d880</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkDocument *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a4090329c34cc13c4a9f0ccfdce4cab81</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkDocument *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>ab78f086eab33695dcf4d762155d28d43</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_document_type</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>afc3d3f8af8e9788684fa9075d4b19ca3</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>gpointer</type>
      <name>get_document</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a9416b4cdce5546b53c01590cf345d916</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_attribute_value</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a2c6ef22a1d3f495cf33644cf2a30dfca</anchor>
      <arglist>(const Glib::ustring &amp;attribute_name) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_attribute_value</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a820411b79a19b85f3b49fd0cf270805c</anchor>
      <arglist>(const Glib::ustring &amp;attribute_name, const Glib::ustring &amp;attribute_value)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a4196505a6fa361087e1331099f163a9b</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a2fbe181bf5391efbc4cd83df6aae15d5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Document</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a7d887df675bfe88dca815e09684e4eba</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const gchar *</type>
      <name>get_document_type_vfunc</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>aa5cad9c4e1d0d2ff7bd66185e1249828</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual gpointer</type>
      <name>get_document_vfunc</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a55bcf80a0f7e9e6d65e9668cd02f5064</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Document &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Document.html</anchorfile>
      <anchor>a03ea1365835687a661421ef1a4ea4582</anchor>
      <arglist>(AtkDocument *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::EditableText</name>
    <filename>classAtk_1_1EditableText.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>EditableText</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>aaedb014b2be5bb8da0e8cd98e9137d59</anchor>
      <arglist>(EditableText &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>EditableText &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>ae737b6852902b81034850970f0c12d89</anchor>
      <arglist>(EditableText &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~EditableText</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>abc7aaf9765a8728be8cec4955a48e614</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkEditableText *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a636b0522789291428a6637a6d7d70b70</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkEditableText *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a091da706928a765d68cca9903344186e</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_run_attributes</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>ae37407f98c293b1c627478c1ab09fc19</anchor>
      <arglist>(const AttributeSet &amp;attrib_set, int start_offset, int end_offset)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_text_contents</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a6a4873f929dc68078ac04626d289cb3d</anchor>
      <arglist>(const Glib::ustring &amp;string)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>insert_text</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a42a9201f189d8ee84315407a1cb6583b</anchor>
      <arglist>(const Glib::ustring &amp;string, int length, int &amp;position)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>copy_text</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a6396f4e74b99391d865ec5249a2a208d</anchor>
      <arglist>(int start_pos, int end_pos)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>cut_text</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a716cc5445588d01148cf7abadef55890</anchor>
      <arglist>(int start_pos, int end_pos)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>delete_text</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a21a956ca942bb0fb2907abb1e2253b05</anchor>
      <arglist>(int start_pos, int end_pos)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>paste_text</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>ab871ed98fae56fc8a7f15cfcc74267b8</anchor>
      <arglist>(int position)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a3eb8a3bdb1c8a27901f2c8669c428685</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a7f4f438d3bbed72d64a988ab1ceff29c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>EditableText</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>ae158517991102b56fbf26235995c12dc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_run_attributes_vfunc</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a1dbced3c1a3cddb2f6b5026d9861899e</anchor>
      <arglist>(AtkAttributeSet *attrib_set, int start_offset, int end_offset)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>set_text_contents_vfunc</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a94fa29260877cc59681573745c299e6a</anchor>
      <arglist>(const Glib::ustring &amp;string)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>insert_text_vfunc</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a8804d8be2962b4c3bf4ab7e1a0fdbfd7</anchor>
      <arglist>(const Glib::ustring &amp;string, int length, int &amp;position)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>copy_text_vfunc</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a0f7fd8e287ea5cd03c24498d8e565902</anchor>
      <arglist>(int start_pos, int end_pos)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>cut_text_vfunc</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>aac4d08e280d76ff17146d71bb3421ef2</anchor>
      <arglist>(int start_pos, int end_pos)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>delete_text_vfunc</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>ae0773ba2194a2c6a23438666c62c03ab</anchor>
      <arglist>(int start_pos, int end_pos)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>paste_text_vfunc</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>a72ea607c3cbad44d064441624c34984e</anchor>
      <arglist>(int position)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::EditableText &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1EditableText.html</anchorfile>
      <anchor>ad7d508f779bfcfb1b0af2a55af905e34</anchor>
      <arglist>(AtkEditableText *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Hyperlink</name>
    <filename>classAtk_1_1Hyperlink.html</filename>
    <base>Glib::Object</base>
    <base>Atk::Action</base>
    <member kind="function">
      <type></type>
      <name>Hyperlink</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>abd51909f27b6aed85b4827505683a11c</anchor>
      <arglist>(Hyperlink &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Hyperlink &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a748c57e0bc6c69dc1f059e2ed2a8fec9</anchor>
      <arglist>(Hyperlink &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Hyperlink</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a46c3c29e700a1c8fdd3206a03f12b210</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkHyperlink *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a99f2d77401d7707606714aaa2299a0b6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkHyperlink *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>aa67b0c75fcc91b7c5eda616d8ee4f9bb</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkHyperlink *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a8eab74455274d14ba2e6a9ff5ce523a1</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_uri</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a75ad4d2cc741a2500af3c626efca76ff</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_object</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a76a73ddbae151631481c61b8aff68605</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; const Atk::Object &gt;</type>
      <name>get_object</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>ab0f85e1b6fcecde119887070327f3494</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_end_index</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>aea6e544340f4b0880b6931e00020b5f8</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_start_index</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a574e97644531c9d9433396afabd21259</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>is_valid</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a35779f410dbeda1f015724d2e958500c</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>is_inline</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>acba76981171a0c4cfa26c1e1d29d61c7</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_anchors</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>af073b29368e1748f5e228800c3648156</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_link_activated</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a033b89a39683263e23abcefc59040adf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; bool &gt;</type>
      <name>property_selected_link</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a7386b392fd76e6917a73d0fe8b569a75</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; int &gt;</type>
      <name>property_number_of_anchors</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>ae0b6e4a91e3a3a24d0a3a3d4cb9d3672</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; int &gt;</type>
      <name>property_end_index</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a4a17730caee0056b4d2f1c648626eed5</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; int &gt;</type>
      <name>property_start_index</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a7e6b935c47a22c90cf231d65e1dca59b</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>af21f10a0718b0a6745f1e974f0919ffe</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual gchar *</type>
      <name>get_uri_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>af194a7bef05db3e85171d175fdd60819</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_object_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a8afaed8f11fbc4914d7c3647c2917206</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_end_index_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a9145f9091618c074bc66bf693ca724b3</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_start_index_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a26c09a6c6924d37df497d95af7168d3d</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>is_valid_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a3e1742105026e816b353840a23258fe0</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_n_anchors_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a97a6b13ef828068907045f1e7e3693d3</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual guint</type>
      <name>link_state_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a2663f5da6c0a19e514945d6704bbab9b</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>is_selected_link_vfunc</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a47498b1d5093e828a5740365d0e13905</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_link_activated</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>a50b6602f4b136a7a48e1b6d199e2a2e7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Hyperlink &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Hyperlink.html</anchorfile>
      <anchor>af90587b7c6392449e9e406f7cc6d3a8f</anchor>
      <arglist>(AtkHyperlink *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Hypertext</name>
    <filename>classAtk_1_1Hypertext.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Hypertext</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a187a48e95508aa456922e66ef8f184bd</anchor>
      <arglist>(Hypertext &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Hypertext &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a5c5a894b068b19120318758aca2cfe93</anchor>
      <arglist>(Hypertext &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Hypertext</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a093efa15eb1501049fb9c6717558a9d8</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkHypertext *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a527649574ec60f6e253bc385628db219</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkHypertext *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>aadafae6feabdc7017323d929c421e4f1</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Hyperlink &gt;</type>
      <name>get_link</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>adaca2de7d96759f284f07b20f0f267bb</anchor>
      <arglist>(int link_index)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; const Hyperlink &gt;</type>
      <name>get_link</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a9e2588009f19677f9cecdbdae93b2bba</anchor>
      <arglist>(int link_index) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_links</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a453a95c2a2421dd0e1dc49c8b73a89c3</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_link_index</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a082dbe83116245a99bc3f1e8a4e55cb8</anchor>
      <arglist>(int char_index) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, int &gt;</type>
      <name>signal_link_selected</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>aede5c080c8d0cbfa7d2e12b0ef8cc061</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Hyperlink &gt;</type>
      <name>get_link_vfunc</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a3d51d7616d4008e8eab8085aee727575</anchor>
      <arglist>(int link_index)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual int</type>
      <name>get_n_links_vfunc</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>afd5b257c53abd3829151221f81487821</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual int</type>
      <name>get_link_index_vfunc</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>af761e0ee732a0fdbd06a9ca4eff8c4b9</anchor>
      <arglist>(int char_index) const </arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>adaa05a5a838f566497324999ac639e3e</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a858a059b2b1b9e9170e97daccd64754d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Hypertext</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a78d1d5a298353da4cec128c7dcdbad39</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_link_selected</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>a404833990e4ea9cdd239b73322cabac3</anchor>
      <arglist>(int link_index)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Hypertext &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Hypertext.html</anchorfile>
      <anchor>acf4d49135820c5191f7189fab2d7664d</anchor>
      <arglist>(AtkHypertext *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Image</name>
    <filename>classAtk_1_1Image.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Image</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a07bb0fa286d798c730bf7dac77506fcf</anchor>
      <arglist>(Image &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Image &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>aad09d45e9e542bbb7017a8c97dc1334e</anchor>
      <arglist>(Image &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Image</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a66ad3f6b5b4a9d82cacc6817da0959b7</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkImage *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a7649474169b7726721b1b5688420c377</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkImage *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a671c40909151052e66300c1324217377</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_image_description</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a53fe6d9b350bf5fd7ba19a6f7179a55c</anchor>
      <arglist>(const Glib::ustring &amp;description)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_image_description</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a857112f6307dfbf5177096f3bb72d80c</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_image_size</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a22a4c26e1642a421ffec41ea6492e11b</anchor>
      <arglist>(int &amp;width, int &amp;height) const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_image_position</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>af22f48ac491ceddb82329076cc63fca9</anchor>
      <arglist>(int &amp;x, int &amp;y, CoordType coord_type) const </arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a0301a217fa7dbd2994a1ff8904e9c8f2</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a39e9cbc314b2bf63805ead79dcd8a745</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Image</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>acbfd02f0474db188114575c0070efbca</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_image_description_vfunc</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a445291439ee8c0b3feac06da935bccdb</anchor>
      <arglist>(const Glib::ustring &amp;description)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const char *</type>
      <name>get_image_description_vfunc</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a4c36cfccf4bff7e7832a4d965e53817b</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_image_position_vfunc</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a75d132a2aa02ebca00020bd010a87de4</anchor>
      <arglist>(int &amp;x, int &amp;y, CoordType coord_type) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_image_size_vfunc</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a16478375c58e928b81c43132a892c593</anchor>
      <arglist>(int &amp;width, int &amp;height) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Image &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Image.html</anchorfile>
      <anchor>a03bbf10f56b004d274029b27bd9d83f2</anchor>
      <arglist>(AtkImage *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Implementor</name>
    <filename>classAtk_1_1Implementor.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Implementor</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a107c3e711d707d84e43eecd412402989</anchor>
      <arglist>(Implementor &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Implementor &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a39733d7aba0cc26fbd085d1220c5fdd8</anchor>
      <arglist>(Implementor &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Implementor</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>acf9348d9662308d4352be7036d347bdd</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkImplementor *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a2ff0ebc78e6c37d678487f588be17ae6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkImplementor *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a468eb4b800275ac8d6ca2130496af275</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a838764354ab8c6d2c84ff291b57fdb05</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a9460675c87793cb667a377568f5d348e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Implementor</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a7c5105ae5d57982fa69fcacdb891e24d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Object &gt;</type>
      <name>ref_accessibile_vfunc</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>acc47f90d8800b06b702ac316677283b8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Implementor &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Implementor.html</anchorfile>
      <anchor>a6b4ff8928c74e07e6c6655865baffbfb</anchor>
      <arglist>(AtkImplementor *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::NoOpObject</name>
    <filename>classAtk_1_1NoOpObject.html</filename>
    <base>Atk::Object</base>
    <base>Atk::Component</base>
    <base>Atk::Action</base>
    <base>Atk::EditableText</base>
    <base>Atk::Image</base>
    <base>Atk::Selection</base>
    <base>Atk::Table</base>
    <base>Atk::Text</base>
    <base>Atk::Hypertext</base>
    <base>Atk::Value</base>
    <member kind="function">
      <type></type>
      <name>NoOpObject</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>ab4f7e9560175a1ec47828fe098914af9</anchor>
      <arglist>(NoOpObject &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>NoOpObject &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>aa435b24be60ac7c878d31b355aa25b94</anchor>
      <arglist>(NoOpObject &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~NoOpObject</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>a3b4924920b26842237bf47bebc57f981</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkNoOpObject *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>aaad07a3a8ce4dea968c53f0098498836</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkNoOpObject *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>af54be60c4815bde603b886cbb876baea</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkNoOpObject *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>ae91fd9a44888365a2978aa53bb9ce9cd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>aded86b1b34b3350cac1366e52c4663d2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::NoOpObject &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1NoOpObject.html</anchorfile>
      <anchor>a0cb9e4aec035de86146f2b798f72a181</anchor>
      <arglist>(AtkNoOpObject *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Object</name>
    <filename>classAtk_1_1Object.html</filename>
    <base>Glib::Object</base>
    <member kind="function">
      <type></type>
      <name>Object</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>abc9637d9681fc84134c9ddd9a263054f</anchor>
      <arglist>(Object &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Object &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a7ccd808ecd9f180d2b3b762f5cff49e2</anchor>
      <arglist>(Object &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Object</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>aa313e8045e88dc42fbdd5f8b4807fc69</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkObject *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ad864427ab22cefa700508f559a65edd2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkObject *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a49f094cb0ca77cae3a9623ec0148f895</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkObject *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a1035c027c592673cfda5375801349a21</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_name</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a13a68f38ef69b789c2007e11d284c9bf</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a7868a3abf0f976b0613b438b443648bb</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_parent</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a84a2e2618308c253a5c4c2d69639475c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_accessible_children</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a3442b9a00d230bdc2c90c9f674449fb2</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_accessible_child</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a083c8dc21bb10a1e8d3c1d3d886365f2</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; RelationSet &gt;</type>
      <name>get_relation_set</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>aee9b9d193da1e4aae578146451692478</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Role</type>
      <name>get_role</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a00decf39d41483bfe7d81e8b000a09bd</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; StateSet &gt;</type>
      <name>get_state_set</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>aa33673dadc19b5e3830fd2531ef13c30</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_index_in_parent</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a341770f5f567bee4f241c7c4030140cd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_name</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a11b8b42866677db3b1a241a4071b0a5e</anchor>
      <arglist>(const Glib::ustring &amp;name)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a7b44bd87ad24140b8f0bbe8ee4267205</anchor>
      <arglist>(const Glib::ustring &amp;description)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_parent</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a05b859f172dcce174b6ec4c52e0b76be</anchor>
      <arglist>(const Glib::RefPtr&lt; Atk::Object &gt; &amp;parent)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_role</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ac51f6e7286a90a5d4daee05160fe4f28</anchor>
      <arglist>(Role role)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>notify_state_change</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a220aafba4f632e755c45bc57f3293689</anchor>
      <arglist>(State state, bool value)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>add_relationship</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a8ccf42eed0a5625d4c46444c73412daa</anchor>
      <arglist>(RelationType relationship, const Glib::RefPtr&lt; Object &gt; &amp;target)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>remove_relationship</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ad98e5624388dfec805132e36f6ba53c4</anchor>
      <arglist>(RelationType relationship, const Glib::RefPtr&lt; Object &gt; &amp;target)</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, guint, gpointer &gt;</type>
      <name>signal_children_changed</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>af33deed50541c4ff8a56c68ac1cbd893</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, bool &gt;</type>
      <name>signal_focus_event</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a1dfb4a26e03550235fe84ff00c733c94</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, AtkPropertyValues * &gt;</type>
      <name>signal_property_change</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a5c6102189337d5e26dbcc7c6a8f80bfd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, const Glib::ustring &amp;, bool &gt;</type>
      <name>signal_state_change</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>af9646bf798c5ab8541b45a39201e2729</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_visible_data_changed</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a2416da5d43130acfd0ac455661927d70</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, void ** &gt;</type>
      <name>signal_active_descendant_changed</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a182510ed65834d96b239fa31817c5779</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::ustring &gt;</type>
      <name>property_accessible_name</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a5f5b74cb23844b99b37be6e9fb571045</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::ustring &gt;</type>
      <name>property_accessible_name</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ab51410354e9d2cfa23c7d5c9561efbff</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::ustring &gt;</type>
      <name>property_accessible_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>aea189ff4f0a8bd3113f173ce0916e5f8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::ustring &gt;</type>
      <name>property_accessible_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a1b34ba420631061c5821e86c77ca5971</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_parent</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a35fafce3b8edde7ccbae0aeb57896e91</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_parent</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a879928839209a1ee766aa19bd92d2472</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; double &gt;</type>
      <name>property_accessible_value</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ab90aeda547191df4395ce03ee0040254</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; double &gt;</type>
      <name>property_accessible_value</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ab8227be92e7bc624257f00532e9ebfec</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; int &gt;</type>
      <name>property_accessible_role</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a8832c96c8bbb9c4aabc3823d8ee883f7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; int &gt;</type>
      <name>property_accessible_role</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a6a5d2424a6eb8e4dfc41040c28e8aacd</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; int &gt;</type>
      <name>property_accessible_component_layer</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a2d13e8afa514a048be3959c7f2415ac1</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; int &gt;</type>
      <name>property_accessible_component_mdi_zorder</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a09e5efd14ddd65a6c5e335a6869ca255</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::ustring &gt;</type>
      <name>property_accessible_table_caption</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a481215c73723a3dc44ea4088a08cd3a9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::ustring &gt;</type>
      <name>property_accessible_table_caption</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>aa5e9cde08bba3dec29fafb06f845725a</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::ustring &gt;</type>
      <name>property_accessible_table_column_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a58f00150a90a1bcf26f928ab55ef11f6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::ustring &gt;</type>
      <name>property_accessible_table_column_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a303dfa9e9ebb8ac4083b612f7f1a0493</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_table_column_header</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a13d39d282f998750a516c80eaf09c721</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_table_column_header</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ae2e8c520d70f55b670382818e3778024</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::ustring &gt;</type>
      <name>property_accessible_table_row_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a9e2b9620ef4627e94762bbc4f1ca6dd2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::ustring &gt;</type>
      <name>property_accessible_table_row_description</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a9997f90a071551d9eb7d78e796a89a05</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_table_row_header</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a5fca91d065e1d2d39f14882342c78d0a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_table_row_header</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ae4ee591805e16557e665a337e031a307</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_table_summary</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a37b547ab60c11c13f5fd3b79e7068491</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::PropertyProxy_ReadOnly&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>property_accessible_table_summary</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ad0e884afda10d679742b64e13d90b50a</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ab6c0fea38fa80a8db962f79706bca6b6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_children_changed</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a70cdaa61ed852885d72d4b23ae71c042</anchor>
      <arglist>(guint change_index, gpointer changed_child)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_focus_event</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a55ade2971976ab91064e44d956dd4e29</anchor>
      <arglist>(bool focus_in)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_property_change</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a3ce5216408c6216502d2c96a016e9ff9</anchor>
      <arglist>(AtkPropertyValues *values)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_state_change</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>ac7838d1294fa83f4aa2280f02f779397</anchor>
      <arglist>(const Glib::ustring &amp;name, bool state_set)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_visible_data_changed</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a56bcdadf8e0cb521023900a04f52501b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_active_descendant_changed</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a4c15f596001f107fa12ab6b02c6ac5f1</anchor>
      <arglist>(void **child)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Object.html</anchorfile>
      <anchor>a896ed35b3df49cb5a439b605c1ce4dd8</anchor>
      <arglist>(AtkObject *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::ObjectAccessible</name>
    <filename>classAtk_1_1ObjectAccessible.html</filename>
    <base>Atk::Object</base>
    <member kind="function">
      <type></type>
      <name>ObjectAccessible</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>ab3c93fa987049e62cb212914c6151f42</anchor>
      <arglist>(ObjectAccessible &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>ObjectAccessible &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a519f058c722d0f70efe7daecaa3471f1</anchor>
      <arglist>(ObjectAccessible &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~ObjectAccessible</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a042911d5c7680e73e4950f9513f822eb</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkGObjectAccessible *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a418f39365081796182a26468acec8a3d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkGObjectAccessible *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a3e55ead94a3c4fe574d1dca3e0b081d8</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkGObjectAccessible *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a5b85926be5fdab14aa1ef9db671c2b3c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a83b1bf11cc078862cfbc7c65fa1835f7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type>Glib::RefPtr&lt; Glib::Object &gt;</type>
      <name>get_object</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a5237c718032945105d72b772297cd849</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type>Glib::RefPtr&lt; const Glib::Object &gt;</type>
      <name>get_object</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>acfba15fe7e643cbdb6f76ce691570215</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" static="yes">
      <type>static Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>for_object</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a236c02ae1ea75cec8db3e07ae6a47b84</anchor>
      <arglist>(const Glib::RefPtr&lt; Glib::Object &gt; &amp;obj)</arglist>
    </member>
    <member kind="function" protection="protected" static="yes">
      <type>static Glib::RefPtr&lt; const Atk::Object &gt;</type>
      <name>for_object</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>a96e311079f82b9b5e2368c6ea72fa5c3</anchor>
      <arglist>(const Glib::RefPtr&lt; const Glib::Object &gt; &amp;obj)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::ObjectAccessible &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1ObjectAccessible.html</anchorfile>
      <anchor>ad064cd66c057c1e305272a0e7ae8a993</anchor>
      <arglist>(AtkGObjectAccessible *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Range</name>
    <filename>classAtk_1_1Range.html</filename>
    <member kind="function">
      <type></type>
      <name>Range</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a53714adcdd043b435a07143b310cfea2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Range</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>af03d12ebdc841f83d574c25d305db509</anchor>
      <arglist>(AtkRange *gobject, bool make_a_copy=true)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Range</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a2ac6cb9af42b516ddb69ccac246ac291</anchor>
      <arglist>(const Range &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>Range &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a097a4de6fe7f36b2a33bb69581138010</anchor>
      <arglist>(const Range &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Range</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>ac4b86970d97438f009d4320d80642bcc</anchor>
      <arglist>(Range &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Range &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>adc56b3e769fa3284bb1932d9f76a8873</anchor>
      <arglist>(Range &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Range</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a5d6a5be9c417c9eb74d0b77bed5406ab</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>swap</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a7046bfd8002a2f5569deab5abb87271c</anchor>
      <arglist>(Range &amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>AtkRange *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a2ff5b93e1d6b1db1c30f0cdaffdacd87</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkRange *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a3cff44b75c8e7e127b5f6435c148ed53</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkRange *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>ab7bd4cc9b4c5bdff2fb371ebc9adecab</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Range</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a6af835d5d2a416ec2dc69d9a2ea0ad9a</anchor>
      <arglist>(double lower_limit, double upper_limit, const Glib::ustring &amp;description)</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>get_lower_limit</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a6476f9de4d6b32f99abb0d1eaa5a582e</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>get_upper_limit</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a603f765a8fe6785848be2c270d0179bc</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>acd3cc01db46745f8e10ed45567aee598</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable" protection="protected">
      <type>AtkRange *</type>
      <name>gobject_</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>a6eea6ef97b622386c2e843e109b0a410</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>swap</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>aa752b782ec6f9f1e9e1e7fb15bf066bd</anchor>
      <arglist>(Range &amp;lhs, Range &amp;rhs) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Atk::Range</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Range.html</anchorfile>
      <anchor>ad9b72771e6e36dbdbf7a6e30b1458d7c</anchor>
      <arglist>(AtkRange *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Relation</name>
    <filename>classAtk_1_1Relation.html</filename>
    <base>Glib::Object</base>
    <member kind="function">
      <type></type>
      <name>Relation</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a79a2c00f770c445116c634a3ec84c1f0</anchor>
      <arglist>(Relation &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Relation &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a63e017420ce4befd4c30caa4ab29a00c</anchor>
      <arglist>(Relation &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Relation</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>aa00a351e877d3db986af1223c0aa859b</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkRelation *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>ab0f2045c77cc80a3a33234c0b24502b5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkRelation *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>adf1190c7f5b9bd05a2df6326de3be904</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkRelation *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a60670602a86a4812af0af5886c9845f7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>RelationType</type>
      <name>get_relation_type</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a12a77bd41e0944dcd3092dd44b04a0c6</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ArrayHandle&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt;</type>
      <name>get_target</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a43d56433bac5c1ad96901e4bdca5d996</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::ArrayHandle&lt; Glib::RefPtr&lt; const Atk::Object &gt; &gt;</type>
      <name>get_target</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a6e6037c097d3cad3223e88a1af8b0270</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>add_target</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a4f4ad2f69975201108d77bc34d4337f8</anchor>
      <arglist>(const Glib::RefPtr&lt; Atk::Object &gt; &amp;target)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a4580ba63dfa8c56c374fcc2aa64eb1a8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static Glib::RefPtr&lt; Relation &gt;</type>
      <name>create</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>ac490ab229919dd681d578dc74a5c19d8</anchor>
      <arglist>(const Glib::ArrayHandle&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt; &amp;targets, RelationType relationship=RELATION_NULL)</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Relation</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a018bb0da9dbc46d4d079236167f7ee54</anchor>
      <arglist>(const Glib::ArrayHandle&lt; Glib::RefPtr&lt; Atk::Object &gt; &gt; &amp;targets, RelationType relationship)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Relation &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Relation.html</anchorfile>
      <anchor>a48d5c60d3a30600bdf456761fc34ef1f</anchor>
      <arglist>(AtkRelation *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::RelationSet</name>
    <filename>classAtk_1_1RelationSet.html</filename>
    <base>Glib::Object</base>
    <member kind="function">
      <type></type>
      <name>RelationSet</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>ad35fe0df2eadc58188b359c3cfae7466</anchor>
      <arglist>(RelationSet &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>RelationSet &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>ac69912d88d70d8bb0071d687ee133c7a</anchor>
      <arglist>(RelationSet &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~RelationSet</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a86a470b604ce8c29ef7cc445f8a438ea</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkRelationSet *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a0458eadd98421354d95aa6b5082ff860</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkRelationSet *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a2272065cbea31e7ba19c9053be0b123c</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkRelationSet *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a4c7b79d440b461e6e425bf829a25f5c5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_contains</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a5d8cb7b1214d468fd53ff44317947662</anchor>
      <arglist>(RelationType relationship)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_remove</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a27c554ac47fd8e328c85521d5ef3d91b</anchor>
      <arglist>(const Glib::RefPtr&lt; Relation &gt; &amp;relation)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_add</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a6a80557979af5ef7babed4217b6b994d</anchor>
      <arglist>(const Glib::RefPtr&lt; Relation &gt; &amp;relation)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_relations</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>aae9807b3bc8a2fccf98a9bac28071121</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Relation &gt;</type>
      <name>get_relation</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a538bd38d9d4e663cdfddbdaeca539a1d</anchor>
      <arglist>(gint i)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Relation &gt;</type>
      <name>get_relation</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a65328bc128f6fbd2105bfa7633db55a5</anchor>
      <arglist>(RelationType relationship)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>add_relation_by_type</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a437be8c938f2229ea22f89b75e12e725</anchor>
      <arglist>(RelationType relationship, const Glib::RefPtr&lt; Atk::Object &gt; &amp;target)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>ae9a9167c08a3b3d942ed993cf2cfc4f2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static Glib::RefPtr&lt; RelationSet &gt;</type>
      <name>create</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>aced8272a8083a745b6f6eedfa47a154b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>RelationSet</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a7d7f55467656bbe4681eb2c13b124b8b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::RelationSet &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1RelationSet.html</anchorfile>
      <anchor>a5f5c94267804b02ea43df30cf278716a</anchor>
      <arglist>(AtkRelationSet *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Selection</name>
    <filename>classAtk_1_1Selection.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a002877071d2d2fefabe92e5cbd75777a</anchor>
      <arglist>(Selection &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Selection &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a4609ea43bcdb156838b8ad0f424e0ae5</anchor>
      <arglist>(Selection &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>aec303efc27925a5c15981d2f18f62df9</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkSelection *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>ab7f5468ebda2c09cb24170b6a07250b1</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkSelection *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a4ea824fa552f7f63314cf938e762d229</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>add_selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>ad7049b1172c9dd0b9849bd2d12a5b134</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>clear_selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>afbcb542e8def62329c1e9cb52d5d24a4</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>ad74b10568731d7f6f503397897702484</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_selection_count</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a034483b48f55ac37c3eac3f0d3a0a6d2</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>is_child_selected</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a08b260cfe65168478cd8c7b333d2e65a</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>remove_selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a01feedb0395d111ad41f77a14e94988b</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>select_all_selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a92e1b742054e0476c6596617d2f8de20</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_selection_changed</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a21c886f1a0e4ee0d6e3293dfbd65733d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a93a878d016d2f576db3c07390d72e558</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a490feb16313697327207e6e777041e69</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Selection</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a085fdb9ae8e3431cbaff2f6f0a32d5d5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>add_selection_vfunc</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>adfecf829b51fe9a026185c31a408af32</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>clear_selection_vfunc</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a1f4114016410eceb7e6dfe4108969ad6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_selection_vfunc</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a917e162fd7d595c0219d7cb8ea9c0d41</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_selection_count_vfunc</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>ac17e8c71d0bcb0efdd2b4ab47f6a3cd8</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>is_child_selected_vfunc</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a14bbd1cc2c2149ee8f026e63c4886240</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>remove_selection_vfunc</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a96e54b0008b8c814a429cebe4a058ad8</anchor>
      <arglist>(int i)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>select_all_selection_vfunc</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>abd539e193806de2c2071fa14be2dbad2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_selection_changed</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>abc335734ac36cf271049aafa749369b3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Selection &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Selection.html</anchorfile>
      <anchor>a3c2d7634f421fa3c5747fa0acea5336d</anchor>
      <arglist>(AtkSelection *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::StateSet</name>
    <filename>classAtk_1_1StateSet.html</filename>
    <base>Glib::Object</base>
    <member kind="function">
      <type></type>
      <name>StateSet</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a2029339343d9d6986af7d35ce57add5d</anchor>
      <arglist>(StateSet &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>StateSet &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>af6c397b288ea925dc5a9830be51a9e05</anchor>
      <arglist>(StateSet &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~StateSet</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>aefdf9fa273128ecad5dbe840c830ae9f</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkStateSet *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>adbd0e5dba45f3eb59141da59cf7ce8ed</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkStateSet *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>af095ba67a81cc186e6b9f512276f8017</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>AtkStateSet *</type>
      <name>gobj_copy</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a13da93101f80ad6d3a297fe9dfebb695</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>is_empty</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>ad60014ebc037244153ce812843ee4dd9</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>add_state</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>aede4c4b8495f9772d35af9da9e77395d</anchor>
      <arglist>(Atk::StateType type)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>add_states</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a88e473c6fd50a2cc71cf6e2222b9eff0</anchor>
      <arglist>(const Glib::ArrayHandle&lt; Atk::StateType &gt; &amp;types)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>clear_states</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a7534af9c87a8e5af0c4033fafcb05f63</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>contains_state</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>ab49dcdfd6f09d04e5dd11fe66be83d27</anchor>
      <arglist>(Atk::StateType type)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>contains_states</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a206a534c4afcc82d1679ce61924d80f5</anchor>
      <arglist>(const Glib::ArrayHandle&lt; Atk::StateType &gt; &amp;types) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>remove_state</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a9f01863fb1490e645e58f1013496d7b9</anchor>
      <arglist>(Atk::StateType type)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; StateSet &gt;</type>
      <name>and_sets</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a770c542a9abc8e97e28e07772d2bf442</anchor>
      <arglist>(const Glib::RefPtr&lt; StateSet &gt; &amp;compare_set)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; StateSet &gt;</type>
      <name>or_sets</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a8561d7c446c4d1a7d27be011c2d966e7</anchor>
      <arglist>(const Glib::RefPtr&lt; StateSet &gt; &amp;compare_set)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; StateSet &gt;</type>
      <name>xor_sets</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a09d5c551ff86ff3f6b20de3bd746e87c</anchor>
      <arglist>(const Glib::RefPtr&lt; StateSet &gt; &amp;compare_set)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>af0a832b033fd0171a5e3d24479b8a0c0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static Glib::RefPtr&lt; StateSet &gt;</type>
      <name>create</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>abaebcea6f7a81790e9c76ea9ed0ac20f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>StateSet</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>a677f991a217c9e4031b0ff4ad78a219b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::StateSet &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1StateSet.html</anchorfile>
      <anchor>ab23628405857278092f4fc24ddca4fe9</anchor>
      <arglist>(AtkStateSet *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::StreamableContent</name>
    <filename>classAtk_1_1StreamableContent.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>StreamableContent</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a3eb99b5389ed33f219e5c57e6e578bc1</anchor>
      <arglist>(StreamableContent &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>StreamableContent &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>acfebb3a71ec6fb510af13018b70f3ece</anchor>
      <arglist>(StreamableContent &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~StreamableContent</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a1d31b1cc124f09b0e2374459abe7286e</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkStreamableContent *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a7e69107bc513a7f3288658d289789eca</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkStreamableContent *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a87b142d8ca1459f685558a9b191ac3be</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_mime_types</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a0cf791acf27c270ca1b991094c0d1335</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_mime_type</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>acb78af36cb7bfd33e767c28da201f267</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Glib::IOChannel &gt;</type>
      <name>get_stream</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a1f601a66e5ab239bb01461ba761af26a</anchor>
      <arglist>(const Glib::ustring &amp;mime_type)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>af04faf4e36324a91e17f62f9a544d656</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a8af479fb148f7a199de3b946cdda9201</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>StreamableContent</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>aea83c07375e552eca86ac18e0ff08c79</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_n_mime_types_vfunc</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>ae6b4d6c08e25477125376a3d0511dd1b</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const gchar *</type>
      <name>get_mime_type_vfunc</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a94e3b6c2f81f67dd2160955090a8d314</anchor>
      <arglist>(int i) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual GIOChannel *</type>
      <name>get_stream_vfunc</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>af3226ec76cb197ad4df38641384a48e0</anchor>
      <arglist>(const Glib::ustring &amp;mime_type)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::StreamableContent &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1StreamableContent.html</anchorfile>
      <anchor>a5e67601b46782d97f4ebf5ed8da1a065</anchor>
      <arglist>(AtkStreamableContent *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Table</name>
    <filename>classAtk_1_1Table.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Table</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a1f07d59e2162e3f9e74d577241ed979b</anchor>
      <arglist>(Table &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Table &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a97204cc70214fc31ad57e1cfe2d67304</anchor>
      <arglist>(Table &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Table</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a34f3c02ca339bd219a00feb1bfd066c2</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkTable *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>af5ffeb6a83f6ea777efccf9d64b82cdb</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkTable *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a848d066a1485bcf869665b42b481b338</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_at</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a4b50a5f631399e3822d5ee8390ba95c3</anchor>
      <arglist>(int row, int column)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; const Atk::Object &gt;</type>
      <name>get_at</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a8ee8463e701593155d108a171614e1e7</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_index_at</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a642c4291054ec74608856d614ff74888</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_column_at_index</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>ae3ddedef2be5b9d63fc0f1eac96d5179</anchor>
      <arglist>(int index) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_row_at_index</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>afac40179aeb4b0a308953bdb9b9ca399</anchor>
      <arglist>(int index) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_columns</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a14e1295467375a79c4de8e448a01f85d</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_rows</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a4f4430eee45e81b16db42333327de332</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_column_extent_at</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>ae71b27e7abdb0c186a9f49296137be0a</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_row_extent_at</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>abe872880d9ee01e481e4e4a11a6f5bae</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_caption</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a211492e0cd0276ce7305bd17b20b581a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; const Atk::Object &gt;</type>
      <name>get_caption</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>accc1795b1859b06b6f660c6433669032</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_column_description</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a5b2a98c6d9bc77244546d7fb3ec88165</anchor>
      <arglist>(int column) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_column_header</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a9ba37fbe0e6261a347c450f53c127a94</anchor>
      <arglist>(int column)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; const Atk::Object &gt;</type>
      <name>get_column_header</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a9017834abde66f038e582ce863cb5ef1</anchor>
      <arglist>(int column) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_row_description</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>afa9f1afb789d11171728f847432728de</anchor>
      <arglist>(int row) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_row_header</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a0bc6a4d62279997e1333fd7385ffd326</anchor>
      <arglist>(int row)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; const Atk::Object &gt;</type>
      <name>get_row_header</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a7638f3a1e51161ec6f8d1e5a0e9a8fa7</anchor>
      <arglist>(int row) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_summary</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a3f716d6991eb20db4fa910a79501a6ca</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; const Atk::Object &gt;</type>
      <name>get_summary</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a54f5cec8a7dc3c85fa2a470ef6d2d2f5</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_caption</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>ad228ba0aed17656a4a357211aaddc5f3</anchor>
      <arglist>(const Glib::RefPtr&lt; Atk::Object &gt; &amp;caption)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_column_description</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a397d3e2c7b1c9a584424be3439fba24f</anchor>
      <arglist>(int column, const Glib::ustring &amp;description)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_column_header</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a4e8716d262dd3c88c90ca311266f9196</anchor>
      <arglist>(int column, const Glib::RefPtr&lt; Atk::Object &gt; &amp;header)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_row_description</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a359eaf67abf327cc9acfff33dadb8a6e</anchor>
      <arglist>(int row, const Glib::ustring &amp;description)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_row_header</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a1a53f96fde5a601678c691525216501c</anchor>
      <arglist>(int row, const Glib::RefPtr&lt; Atk::Object &gt; &amp;header)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_summary</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a73bbcf6f372e742cbb28bfa16592f300</anchor>
      <arglist>(const Glib::RefPtr&lt; Atk::Object &gt; &amp;accessible)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ArrayHandle&lt; int &gt;</type>
      <name>get_selected_columns</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aa3c2779dfd44ee2636d844cad704010b</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ArrayHandle&lt; int &gt;</type>
      <name>get_selected_rows</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a73f1c6d4e7266bb0ba58b4f61afae7a2</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>is_column_selected</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aba58ad21e97f5083670282a09b369b9f</anchor>
      <arglist>(int column) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>is_row_selected</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a4246b47ae50a6c612112a09361f434e3</anchor>
      <arglist>(int row) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>is_selected</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a7e6269a5274d11017dd7c447f3cf2ab7</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>add_row_selection</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aa2045fb8c50eede912a9bbf8912d9dfc</anchor>
      <arglist>(int row)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>remove_row_selection</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aef751c6cb1cbaf5d199d9b80dcfe03f1</anchor>
      <arglist>(int row)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>add_column_selection</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a165569ada31b77d5a633cf31121ebf35</anchor>
      <arglist>(int column)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>remove_column_selection</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a1a03bad72a13fe55d98add3be68108c8</anchor>
      <arglist>(int column)</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, int, int &gt;</type>
      <name>signal_row_inserted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>acbe3735991626924b6dcc8f7b1915622</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, int, int &gt;</type>
      <name>signal_column_inserted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>abbc9f70556b5cde5e911483c6ac61bea</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, int, int &gt;</type>
      <name>signal_row_deleted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a08600b139d6c8a474ac1ca8b15246952</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, int, int &gt;</type>
      <name>signal_column_deleted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a79e05322c5575e18e58e559628eb604c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_row_reordered</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a91fca840ae1b2887aa64387a0d0b2fe6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_column_reordered</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a8492fbf792a4c5884cf4570e6ac95ced</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_model_changed</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>abdc95249c230f00d2e7f2529a253fdb6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a5dbef0d1782da1102fb2703038de84b4</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>accd1b4580b4414b05cdb08a369399a9a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Table</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>ae3f99b729974c72921796c2972f2cca2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_at_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a3a47fd43520385bc7c39b93cee374f18</anchor>
      <arglist>(int row, int column)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_index_at_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a1f31195e65263f08ba2b45e408d1d36c</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_column_at_index_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a8bde17db4b4556be2f1a6d377678025a</anchor>
      <arglist>(int index) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_row_at_index_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a3d98b93b07d9720d4df20359033f9c04</anchor>
      <arglist>(int index) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_n_columns_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a7eb07a5a3bd58f8bbbb6b8994a1d41b0</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_n_rows_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a21dc8564989619f7d8220b6321a854b5</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_column_extent_at_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a46f4ba4b6acc53cef0de3942e720a609</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_row_extent_at_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a556b647d788c9eeb3181842b44f801b2</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_caption_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>ac0058463e4b1ee4fdc2cabd838ef1bf5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const char *</type>
      <name>get_column_description_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aee97bc3ef086f936750b01d1346ec9b1</anchor>
      <arglist>(int column) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_column_header_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a235aac0239e9619197d5b1e3fc162bcf</anchor>
      <arglist>(int column)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual const char *</type>
      <name>get_row_description_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>ad9aa33e6e59eb9b01537061a67cb23b6</anchor>
      <arglist>(int row) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_row_header_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a3c185a79b24cd0cbfbe0d934b9e31956</anchor>
      <arglist>(int row)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::RefPtr&lt; Atk::Object &gt;</type>
      <name>get_summary_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a00741db880ac2c6b9a6219cd0bbbbd1a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>set_caption_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aa3a44286d579753de653972aa39bc3e5</anchor>
      <arglist>(const Glib::RefPtr&lt; Atk::Object &gt; &amp;caption)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>set_column_description_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a1b523e525875bd715d9145d2339e0a8b</anchor>
      <arglist>(int column, const char *description)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>set_column_header_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a3bd916ee09e6eaa309f8aedabd1c0325</anchor>
      <arglist>(int column, const Glib::RefPtr&lt; Atk::Object &gt; &amp;header)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>set_row_description_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a941970119e89be3d92bcebb4916a42c6</anchor>
      <arglist>(int row, const char *description)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>set_row_header_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>afa145591edb110af261349c2b27d6a77</anchor>
      <arglist>(int row, const Glib::RefPtr&lt; Atk::Object &gt; &amp;header)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>set_summary_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a3add1b7c521d33a1a186d75d691125d9</anchor>
      <arglist>(const Glib::RefPtr&lt; Atk::Object &gt; &amp;accessible)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>is_column_selected_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aaaf80f8ae386b23a9dccfe5a35959e2a</anchor>
      <arglist>(int column) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>is_row_selected_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>ad9e64dc45557a01085240ea74083192b</anchor>
      <arglist>(int row) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>is_selected_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a00daf048df6d1f9ea254a4ee19952f30</anchor>
      <arglist>(int row, int column) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>add_row_selection_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aee629137df2ea8edd8c34734aca97a15</anchor>
      <arglist>(int row)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>remove_row_selection_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a59d9b04f23f6e28d18696e1380acb425</anchor>
      <arglist>(int row)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>add_column_selection_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a5da5a90e88f8b6ff060797abed26d2c9</anchor>
      <arglist>(int column)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>remove_column_selection_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a51ee71013d878a061b7320a44f967bcf</anchor>
      <arglist>(int column)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_selected_columns_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>aaf11986c037588f81a1f7e144e7366cd</anchor>
      <arglist>(int **selected) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_selected_rows_vfunc</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a400cd66c2d53eae11947de5e96cedd7a</anchor>
      <arglist>(int **selected) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_row_inserted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a52af90f686a8f29ac6397b9759d5d3f6</anchor>
      <arglist>(int row, int num_inserted)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_column_inserted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a7f3f234c028e4314ab8dd1810a7e1cbd</anchor>
      <arglist>(int column, int num_inserted)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_row_deleted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a62098f5f91740e2123139418209b7df0</anchor>
      <arglist>(int row, int num_deleted)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_column_deleted</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a6552422ab268a7923f5841ee979c3cdb</anchor>
      <arglist>(int column, int num_deleted)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_row_reordered</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a149a2225e941632fe6d2c71a083aa5da</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_column_reordered</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a316c0007b74cd843494fe41d9643f6a6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_model_changed</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a4a70f9cc48913fbce380d0e77ad1b19d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Table &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Table.html</anchorfile>
      <anchor>a85251fd251158cdd97aa87b8c137f62d</anchor>
      <arglist>(AtkTable *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Text</name>
    <filename>classAtk_1_1Text.html</filename>
    <base>Glib::Interface</base>
    <member kind="typedef">
      <type>AtkTextRectangle</type>
      <name>Rectangle</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>aef8ed58f4c770e63c2381b543339dd15</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Text</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a028e5126d3aa1e368004179981efcd3d</anchor>
      <arglist>(Text &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Text &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a2c0fca7fe37ad8e7e923568d04b81df7</anchor>
      <arglist>(Text &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Text</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a57d232be95ed1a2eb11c6e245e8474d9</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkText *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a89fa4c5f3fdc6b59a811da1609571bdf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkText *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a2f3329b4e844483278abd627a141142d</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_text</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a8f749c1f6dc15ffef4e27766ea66655f</anchor>
      <arglist>(int start_offset, int end_offset) const </arglist>
    </member>
    <member kind="function">
      <type>gunichar</type>
      <name>get_character_at_offset</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a061b8607e273fb85e84162a0a0e5b47b</anchor>
      <arglist>(int offset) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_text_after_offset</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a3850bea8df6900731de05add95c3dc36</anchor>
      <arglist>(int offset, TextBoundary boundary_type, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_text_at_offset</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>af4a06a65abef1a65af82cc11e54adf3f</anchor>
      <arglist>(int offset, TextBoundary boundary_type, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_text_before_offset</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a8472685388551749d87a43ce62982644</anchor>
      <arglist>(int offset, TextBoundary boundary_type, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_string_at_offset</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>adf22ecc82e21072ef153559362566145</anchor>
      <arglist>(int offset, TextGranularity granularity, int &amp;start_offset, int &amp;end_offset)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_caret_offset</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a10e19ea8a7bb6d5576ef69eb64db8e94</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_character_extents</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>abfce57bc598c220bc3de0ea9a26f11a4</anchor>
      <arglist>(int offset, int &amp;x, int &amp;y, int &amp;width, int &amp;height, CoordType coords) const </arglist>
    </member>
    <member kind="function">
      <type>AttributeSet</type>
      <name>get_run_attributes</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a134728ff97897f45014d383502d9cd0e</anchor>
      <arglist>(int offset, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function">
      <type>AttributeSet</type>
      <name>get_default_attributes</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a48b27d8ac35f7e21a9910fe84c84cdb0</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_character_count</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>af0097531b66f229867b7b8b2b49d4ddb</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_offset_at_point</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a933eb7fc0a5a77d1b4393d711bc1719f</anchor>
      <arglist>(int x, int y, CoordType coords) const </arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get_n_selections</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a7027005265ad0212f25c50b53ff775e1</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_selection</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>aeee0be1f96d9368c68934e66a23921da</anchor>
      <arglist>(int selection_num, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>add_selection</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>af6cb6584fa1bd0a3541a3d566a356d03</anchor>
      <arglist>(int start_offset, int end_offset)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>remove_selection</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>ac0d02f671ae48bd11f6a1c451c399ef9</anchor>
      <arglist>(int selection_num)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_selection</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a7e24f7bc27300fa7312fb8742192ac65</anchor>
      <arglist>(int selection_num, int start_offset, int end_offset)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_caret_offset</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>acbd9dd3ed20867c7665f97e4f9d521d4</anchor>
      <arglist>(int offset)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_range_extents</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>aa58bbce3c64f2c60a92c70703d310495</anchor>
      <arglist>(int start_offset, int end_offset, CoordType coord_type, Rectangle &amp;rect)</arglist>
    </member>
    <member kind="function">
      <type>AtkTextRange **</type>
      <name>get_bounded_ranges</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a0d547bd9d5c17d52d16addd236e7b8a2</anchor>
      <arglist>(const Rectangle &amp;rect, CoordType coord_type, TextClipType x_clip_type, TextClipType y_clip_type)</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, int, int &gt;</type>
      <name>signal_text_changed</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>ad1e45b9c4f4cd64cbb22f3a77e709118</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void, int &gt;</type>
      <name>signal_text_caret_moved</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a67ced6db6a7775f02a13af488c323fd7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_text_selection_changed</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>adfe530de29194f3693892b6b83c5244d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::SignalProxy&lt; void &gt;</type>
      <name>signal_text_attributes_changed</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a2edee4d1d755ef6045af23adb1c33dd5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a60ea0ab1d7e02db112e78daead23abde</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a6175dad0ec56e49fb1b8f43f97d6a4af</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Text</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a4abd0b8b277ee531e457959b763e4688</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::ustring</type>
      <name>get_text_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a38446df16438186f00d2e6c185aec843</anchor>
      <arglist>(int start_offset, int end_offset) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual gunichar</type>
      <name>get_character_at_offset_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a7dc54968eec4be1da076392bf0739a58</anchor>
      <arglist>(int offset) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::ustring</type>
      <name>get_text_after_offset_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>ae75ece1bc7052a9ce77ff8e39490e631</anchor>
      <arglist>(int offset, TextBoundary boundary_type, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::ustring</type>
      <name>get_text_at_offset_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>af28b3d2490a25f7bc9ac6458210b379f</anchor>
      <arglist>(int offset, TextBoundary boundary_type, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::ustring</type>
      <name>get_text_before_offset_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a12f7c5a3ebc090a9787ef48ff5b5148d</anchor>
      <arglist>(int offset, TextBoundary boundary_type, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_caret_offset_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a200e647b0bffaf009aa92349202e2613</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_character_extents_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a625281b9f1a45288dfd05e69d6f21197</anchor>
      <arglist>(int offset, int &amp;x, int &amp;y, int &amp;width, int &amp;height, CoordType coords) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual AtkAttributeSet *</type>
      <name>get_run_attributes_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>aeedf1b3c5837028d4888143fc07b02d4</anchor>
      <arglist>(int offset, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual AtkAttributeSet *</type>
      <name>get_default_attributes_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>aaee88d5014476c05c4ca911d9878fdaf</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_character_count_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>af39e032a8cf76bbc05e88bbfaae4a874</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_offset_at_point_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a99d21f6dceb050aee0bf4786eac298a2</anchor>
      <arglist>(int x, int y, CoordType coords) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual int</type>
      <name>get_n_selections_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a1c62fb75eb70aad2ef535c04fedcde5b</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual Glib::ustring</type>
      <name>get_selection_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a170ea04bc324ae8c249dc3e43f7fe28c</anchor>
      <arglist>(int selection_num, int &amp;start_offset, int &amp;end_offset) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>add_selection_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>adcf6c2321bd73c525abccd50f4a4b24f</anchor>
      <arglist>(int start_offset, int end_offset)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>remove_selection_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a85ee3d0a51162dbf6060f28f0c3a8fd9</anchor>
      <arglist>(int selection_num)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_selection_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>abf5a391ed37a8f8f061ab0ae5c54f3ac</anchor>
      <arglist>(int selection_num, int start_offset, int end_offset)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_caret_offset_vfunc</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a44fd5f06d5bebd94e08ecfd0f9a316dc</anchor>
      <arglist>(int offset)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_text_changed</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>acec053d08f490ce3c00f1279ed133ce0</anchor>
      <arglist>(int position, int length)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_text_caret_moved</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>ae5f768a698cf3ba6aadfba48a9dc9b2d</anchor>
      <arglist>(int location)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_text_selection_changed</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>aaf45255b13e80d8552ed3cceee245947</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>on_text_attributes_changed</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a28e94c8c8ff33a3a1202fbd966af96b4</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Text &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Text.html</anchorfile>
      <anchor>a112fb37843d9647af0ca48654c59b3c4</anchor>
      <arglist>(AtkText *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::TextAttribute</name>
    <filename>classAtk_1_1TextAttribute.html</filename>
    <member kind="function">
      <type></type>
      <name>TextAttribute</name>
      <anchorfile>classAtk_1_1TextAttribute.html</anchorfile>
      <anchor>ac64aa4b57241faccd821ecb7585c9541</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>TextAttribute</name>
      <anchorfile>classAtk_1_1TextAttribute.html</anchorfile>
      <anchor>a0896075a32b7a606cadcee9fa5a31002</anchor>
      <arglist>(BuiltinTextAttribute attribute)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>TextAttribute</name>
      <anchorfile>classAtk_1_1TextAttribute.html</anchorfile>
      <anchor>a1f9bdb7bc76f3acc5ebc62979c5ece1c</anchor>
      <arglist>(int attribute)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>operator int</name>
      <anchorfile>classAtk_1_1TextAttribute.html</anchorfile>
      <anchor>a2b2bd880d92d39449062e44945aa2c7a</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function" static="yes">
      <type>static TextAttribute</type>
      <name>for_name</name>
      <anchorfile>classAtk_1_1TextAttribute.html</anchorfile>
      <anchor>a7287f7e177e87a5558f3a220fffe720a</anchor>
      <arglist>(const Glib::ustring &amp;name)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static Glib::ustring</type>
      <name>get_name</name>
      <anchorfile>classAtk_1_1TextAttribute.html</anchorfile>
      <anchor>a057f88c2a45781ab896551fb36cd80b1</anchor>
      <arglist>(TextAttribute attribute)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static Glib::ustring</type>
      <name>get_value</name>
      <anchorfile>classAtk_1_1TextAttribute.html</anchorfile>
      <anchor>a6bc77e0d21edd5724e8acae5515228c8</anchor>
      <arglist>(TextAttribute attribute, int index)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Atk::Value</name>
    <filename>classAtk_1_1Value.html</filename>
    <base>Glib::Interface</base>
    <member kind="function">
      <type></type>
      <name>Value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>af148f6dd41f39f0539179fabd2d25912</anchor>
      <arglist>(Value &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Value &amp;</type>
      <name>operator=</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a9954c7c77622899961e9201ad5422ecd</anchor>
      <arglist>(Value &amp;&amp;src) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a5a3162eee2513bff76b1ee089af48839</anchor>
      <arglist>() noexcept override</arglist>
    </member>
    <member kind="function">
      <type>AtkValue *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a1d492104dfbc24ca3586889e1c9dd122</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const AtkValue *</type>
      <name>gobj</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a1e9774208afa33f5536d0af2f1542724</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_current_value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a413b3aa759306e5453c52c3cc633bbdd</anchor>
      <arglist>(Glib::ValueBase &amp;value) const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_maximum_value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a05900879b78b99af2f608f8aa6225043</anchor>
      <arglist>(Glib::ValueBase &amp;value) const </arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_minimum_value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>aa846b94c5afd243ad9b6488f3c882b30</anchor>
      <arglist>(Glib::ValueBase &amp;value) const </arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>set_current_value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a5f68e4192b070a56f2f5dbdc29d18ef1</anchor>
      <arglist>(const Glib::ValueBase &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>get_value_and_text</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a57b6e5cd2259cc1b9d0d0f893b54aacf</anchor>
      <arglist>(double &amp;value, Glib::ustring &amp;text)</arglist>
    </member>
    <member kind="function">
      <type>Range</type>
      <name>get_range</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a946df62496c55e3a249d132b26d368d3</anchor>
      <arglist>() const </arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>get_increment</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a98c494ad7efd61f3e018c9b755fbf9ef</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>afe294122ffa7695ef429183e6abf1f39</anchor>
      <arglist>(const gdouble new_value)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static void</type>
      <name>add_interface</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>ac8564e11ac77f72d5c57b2db14371453</anchor>
      <arglist>(GType gtype_implementer)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static GType</type>
      <name>get_type</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a758297abebea6e5589e2227973b92d71</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>Value</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a5e4febae93ac4a52bc5618588f45de1d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_current_value_vfunc</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a551af308c0c75563f3868d0ad2cd33d9</anchor>
      <arglist>(Glib::ValueBase &amp;value) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_maximum_value_vfunc</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a207fc4a161bea34cc85d27e995146b9d</anchor>
      <arglist>(Glib::ValueBase &amp;value) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>get_minimum_value_vfunc</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>ab58f2f48c88ff92b07fced0f8434bbea</anchor>
      <arglist>(Glib::ValueBase &amp;value) const </arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_current_value_vfunc</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a1eb831ae8176d444fa8320bb1852a4cf</anchor>
      <arglist>(const Glib::ValueBase &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Atk::Value &gt;</type>
      <name>wrap</name>
      <anchorfile>classAtk_1_1Value.html</anchorfile>
      <anchor>a68a42fa970f6678863e0d5163fc58439</anchor>
      <arglist>(AtkValue *object, bool take_copy=false)</arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>Atk</name>
    <filename>namespaceAtk.html</filename>
    <class kind="class">Atk::Action</class>
    <class kind="class">Atk::Attribute</class>
    <class kind="struct">Atk::AttributeTraits</class>
    <class kind="class">Atk::Component</class>
    <class kind="class">Atk::Document</class>
    <class kind="class">Atk::EditableText</class>
    <class kind="class">Atk::Hyperlink</class>
    <class kind="class">Atk::Hypertext</class>
    <class kind="class">Atk::Image</class>
    <class kind="class">Atk::Implementor</class>
    <class kind="class">Atk::NoOpObject</class>
    <class kind="class">Atk::Object</class>
    <class kind="class">Atk::ObjectAccessible</class>
    <class kind="class">Atk::Range</class>
    <class kind="class">Atk::Relation</class>
    <class kind="class">Atk::RelationSet</class>
    <class kind="class">Atk::Selection</class>
    <class kind="class">Atk::StateSet</class>
    <class kind="class">Atk::StreamableContent</class>
    <class kind="class">Atk::Table</class>
    <class kind="class">Atk::Text</class>
    <class kind="class">Atk::TextAttribute</class>
    <class kind="class">Atk::Value</class>
    <member kind="typedef">
      <type>guint64</type>
      <name>State</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ac8c786b6146e720a10e40c9a6483f153</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>Glib::SListHandle&lt; Attribute, AttributeTraits &gt;</type>
      <name>AttributeSet</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>a8759d34cf55e51e9f1a43d0bf4a6db31</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>CoordType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga6c71d0aa1d2e5c4917bafa3f12c811c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>XY_SCREEN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga6c71d0aa1d2e5c4917bafa3f12c811c2afa31df89eb2fbb9862967e3a3e3fadb4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>XY_WINDOW</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga6c71d0aa1d2e5c4917bafa3f12c811c2a1ee9258286acd6ac79e7f649de697715</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>Layer</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_INVALID</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8ab1d38350db6a7d49bea9a42e36bc7cad</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_BACKGROUND</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8aaffd8c676fe1537d7601867324ac6bfa</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_CANVAS</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a11e333012ad71145d9526591f0ba1a2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_WIDGET</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a2563fc72826b830d266cab03826549e3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_MDI</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a17f0de0715b1e8ace446e4e07153bffb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_POPUP</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a2db25c44dee98b88362a3f32ff011923</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_OVERLAY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a9a37fc12a0d7a09e7250f6e548d6d739</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_WINDOW</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a6909bfdaa74f71006dbdb879e36c147a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>Role</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga19e4dff08645ca208cdf524836a1be27</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INVALID</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a03b7adf147abb99a34364887f60e2f54</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ACCEL_LABEL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a90fb348c65faa9edba2d4b12f57362b7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ALERT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a751119ceaf56a7e1d498fd0865256db5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ANIMATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8bbdc9aa636a56d50e5b2252c4b71de1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ARROW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a4e32033a4a294decb90b75426efccd51</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CALENDAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a729cc798f3a871420edf7b84e5fce29a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CANVAS</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27acc1d1fb0dde94d186cd240de4c83fb2f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CHECK_BOX</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a99dc1127fad81abe98e54feadd8edaef</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CHECK_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6e41d9ae82e9d619d8e2007de55a0d83</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COLOR_CHOOSER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a28ea532fedc5f1492f55ee42ba0d110e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COLUMN_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac562110645a30d7ffe3f0cc2414752a6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COMBO_BOX</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a249384b8d5b79299f62b88fc0d91e5ad</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DATE_EDITOR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aed6ca916b1d54f9bf12c058473c4e80f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESKTOP_ICON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6c6f6aad475905b77817469b6bc9b04d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESKTOP_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ada71f6f6bbca69523b8f05b9798101f1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DIAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac949b07517c4f4eb51c43769daea900e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DIALOG</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a07c8c90ac361cc44215bc9a13cc9d63d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DIRECTORY_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afcf15a284444b646fed5b7a2c56f5f60</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DRAWING_AREA</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a2fa15e4f6b6410032087a98829e17904</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FILE_CHOOSER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8d2b5f26392a637571fc3b0340aba1c6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FILLER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a9577893f52a7ca0d3c8097f8c36c4117</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FONT_CHOOSER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a964762ebfbe131d0d43a531ba313a0d3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8da375d17cefb5a54b15b3d94cc28f62</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_GLASS_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6ea3843b8201512a88a5efd20252092d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_HTML_CONTAINER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a4298c2d598ded8be2c8c263882af28c8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ICON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6fe1b16f7cc09e7b2f18903658d9d3b7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_IMAGE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac2730b9c7eaf67367ac3c0f078220be4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INTERNAL_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a63411be70a6256c25661b36619f991b6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LABEL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad9d6252511d4e87c47c34e7721a64718</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LAYERED_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac9e80d237b517896ae4c6a5d1ae69812</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LIST</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a976a583ee8932ede9a6e3386404ca163</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LIST_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27acf53a383aadfd934ee44868d1b894f04</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MENU</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac2b15d7e6319620647912ebeba520ca2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MENU_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a96956fae7c290317391e196997b73962</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a44d66448a05cac51943120a980ada0c6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_OPTION_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a84919c9223cf1c1956bc63bab4a06f3f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PAGE_TAB</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a30cdee73954df268b35ad60fc7af7853</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PAGE_TAB_LIST</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7b253b6220fcacf99d5d5cde334fdfab</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PANEL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a93d64dd645e4a919bffd28187ad4d73c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PASSWORD_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac0050f6c421892b3f27d71432dc8d805</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_POPUP_MENU</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad64cf2b1b9bb4c135bc82c2d2150ce29</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PROGRESS_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0ee7ee60e2887834ed3c725e8a27e6b5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PUSH_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a893358f2d67d103974775b66973c449f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RADIO_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a063d6d55f8b92793e2f040014fce61b9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RADIO_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8ed4fe61e40eb9110f80a643fc00be61</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ROOT_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a522edfb1bad8ea4e20cfff5b2d4a4b54</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ROW_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0673b83465635c405e96ff2319ab7768</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SCROLL_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa7dcad3ca39aa6cfe8e7e2cac8613ad6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SCROLL_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a77b4d9445e55372af979ca6e9bd3ea44</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SEPARATOR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a3c73d2fb94f28c3826c91971f105157a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SLIDER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a72284d576401425d7d9d25dc227418b8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SPLIT_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a854d707133a53c61d2a7f8abd51c662a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SPIN_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ae196510d3430ed6bd20c180cc20459d7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_STATUSBAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aca33485bd1b36ab060e0ee40f0fb146f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a23a1885658083e4b711ba07e54c977a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_CELL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a37b8c0a0962de75d1c5543aee0c7f334</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_COLUMN_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab4e1a16cfa76e026959c6973b6d3065f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_ROW_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a764cac0e6c79835535c01068f3048f9b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TEAR_OFF_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0e7d46e59c365b1da54969745015f76a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TERMINAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a9a6bb25c658677bb58e1bda9828c1c2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aae92d12d274c258e1e16b02b1dfe72b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TOGGLE_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a3a9554aa8f05b3fd255e395a75e13a65</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TOOL_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a9e57841f611edac11ce5cb99886241ac</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TOOL_TIP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa486c34f56938cc27fa35ca7d3e08b63</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TREE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a63c6af1d80435c09ed5b450eb6604867</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TREE_TABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a16edf707b28f7c93009964498ae556d1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_UNKNOWN</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a922437fd0b6fbddbf4f89f1733b8a280</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_VIEWPORT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa0c2aa0067292f8ad5e74bf77741d3a4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_WINDOW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a2360eb9b8e8509c4002ddfee5a9d0add</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a1402405b5b60ac46a03ba9e1b330ee10</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FOOTER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a3c73c67b2af4e6ad007608b6087728ee</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PARAGRAPH</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad2aebfb6550f478089da3c5a999270dd</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RULER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7fb381b91ab96dafa1e6bd5895d01cb2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_APPLICATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27acbd3e3422a0c938be7d7321d3b81f368</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_AUTOCOMPLETE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27af63525acc7814e9502808813e87fa5b8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_EDITBAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad2b191ec8ae853c6dd65f4878de54122</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_EMBEDDED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afe3884c520dcfbd0e8e24d1351175401</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ENTRY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27adbdabc7fa7498302460bd8037c2789eb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CHART</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aeb0574171eab9711dcd432e4f82e1146</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CAPTION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a642a134eed486e055b8880a60f72f4ca</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6815eb11edc3f47cc3ffe55a14c4308a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_HEADING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a78988aacdcea3f7f08a2e1d16e29cb12</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PAGE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a1d1cd19b29d207ec9bd026ed23169425</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SECTION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a985d679f4284b48f3cb49bb2cb931a3c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_REDUNDANT_OBJECT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a18b9db38b50d1d36526a04cb839f8802</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FORM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afcfaf66601c4630eb9d8cd52e1bb93c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LINK</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7cd3b449a443269a30a8176bd11597ff</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INPUT_METHOD_WINDOW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7087be6665736ed5626110232b72e591</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_ROW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a85e5571d7f42590c70da2826138e10a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TREE_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0929bf66fb02ff727e9ec90ba88436a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_SPREADSHEET</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afdad04066fe7ecd1a438a07dad12984d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_PRESENTATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0e2eb5a6b3d5ec4fd7b85028ea0f9cd2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad437d1c0af8ac4382c3645b059a3c5a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_WEB</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aaf8bb5440dcefd451aecdfefbc1dd25f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_EMAIL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aca847b06edcf30ffdae5714fe2403fdb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COMMENT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aff2f2f991f22f2fec8d17a01aeb3d9c1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LIST_BOX</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7c9ba8c94939f3cd9e897cf72be9ada3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_GROUPING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab705a38b371ef3fa9db7dbca92c868fe</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_IMAGE_MAP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a60b619fe5eee23ddb8faa812f0528426</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_NOTIFICATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a89a5954fa09c292ed2ac5c303a44b5b9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INFO_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa78f97904dd22f8c2315a2447213a17e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LEVEL_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afbd314cc3c14ca683861355c59daa65a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TITLE_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0c8599152d2d4bab7943665ebd353c68</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_BLOCK_QUOTE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab14b366c2a0206384fb6cf098134793d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_AUDIO</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ade73b7b1b708d0426fb257524c8faea7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_VIDEO</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ade1aadbc70a285548c4986763c910341</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DEFINITION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad542b7a01f095909915e229d7287cfe9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ARTICLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27abf754dd34add6748625086310d05dea6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LANDMARK</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a06a285cfa19f9d1d2bd6f82c91145591</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LOG</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a803f7511f98ed1955b1cfc0e16e4fb7b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MARQUEE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afb44f84d3bfab6a6881a1462e5296696</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MATH</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a5c18a5acfa9b97641452acd8537280be</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RATING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad0a9063c6d3bf4f279625a0b72cb33ae</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TIMER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a698ad4a75016d000d920378982f8b3f9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESCRIPTION_LIST</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a1e4ef7c6a1153bcb26700ea2527b5967</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESCRIPTION_TERM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a4f281b31a47f58f26928c4722dc16ce3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESCRIPTION_VALUE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a07d8d327bcd58a01a91003c6c9e42594</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_STATIC</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a734952c6ba04ec0162ed3b1d952d6c64</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MATH_FRACTION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a34023fd8176925431aa304cc1f701619</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MATH_ROOT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27af60918fa4c53179e6126f0ca3bac1610</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SUBSCRIPT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27accad65056cdd6186b30f8105740cfd2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SUPERSCRIPT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab49bc13be45410b0201b3c56c3afd16c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LAST_DEFINED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac2a78ab956bc9edb48ef9c20e7fa4db2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>RelationType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_NULL</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a08ff14d1f85fc39fb99f92958408849c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_CONTROLLED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ac85893b44b851917a24b02e56694bfdd</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_CONTROLLER_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5af442a9c480c217aa87cf5fe9cbc4fad2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_LABEL_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a9073f39a105ccb105ce72d670488fe1d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_LABELLED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a48f99753886b49bab1794cb261ad2850</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_MEMBER_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aed90e228ea7ab72f851bab3d36449247</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_NODE_CHILD_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a0bbdde6e6e1a4ddc9a88c73b71002a8d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_FLOWS_TO</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ad83a326fd91c165e6fc2746898ebb6ec</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_FLOWS_FROM</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aff86319aa82ffa35a10597fed2413a44</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_SUBWINDOW_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a24dca51b60973eae594a5ce636395871</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_EMBEDS</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aad0bb4e210e16a8b8c9e5f0294c77ea6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_EMBEDDED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ac2955b63a70bb1e0cec6cf1ad6f0a7d4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_POPUP_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5af7a0b46b2b9046910913117fe7312b88</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_PARENT_WINDOW_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aacf63b7fdd12da9af60ab5b1ddc8b5c6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_DESCRIBED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a071dce0a4eb78f24ab64d4e536da85f4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_DESCRIPTION_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ac3fc29e5101dcc1f22cdf01fbf90d6df</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_NODE_PARENT_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a4c4c308f2b1bd5b2f112b13cb25e08d6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_LAST_DEFINED</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a1809f2d94842f78a8e5387698ec73915</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>StateType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga2b925d92032639815edcfd9b0f53d15e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_INVALID</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaf38c9a5ee701bd869fa693dde077ae94</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ACTIVE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea3b96a8572f1fb31ba171e8eb76d44434</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ARMED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea36f02ef2ddb01fcb26d33caa4896c7be</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_BUSY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea3d81e4407381a35205154904c27d4b07</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_CHECKED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea6a36533b9c0bcc4e1f34f461ff8cd137</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_DEFUNCT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaf15f11d7b48b1119169c80789a3ea6c9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_EDITABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea35fcaac7746569ade7f7386832603de7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ENABLED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea74d7172d6fd23d38d5627c00276c39fc</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_EXPANDABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eafc4c8c22b95953a4d65ee30827873c6c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_EXPANDED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaef89a6238be3b2983589cea2c8e79eee</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_FOCUSABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaa0021f2c26dba14838aff2420c8f4470</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_FOCUSED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea2a4d25fbbc37ecbdd0568fd1df6908a5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_HORIZONTAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea19eec6e9b6278a938a80a69c845768bb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ICONIFIED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea854aab00b1fcfaeb21a3e3166e54bb71</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MODAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea54d686d0481e36bdc4fcddf87631691b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MULTI_LINE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea3cab9f3ac425aa5ba0c67e59f8794d43</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MULTISELECTABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea590b7d91649336348d28f6f55c18cfbd</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_OPAQUE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea9e46ab4b9bce571c2513a3be9b6b9604</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_PRESSED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea245197daf9437f95382b79396f48792a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_RESIZABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead336da6c742fc4ce3531aa97b74841f6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SELECTABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea8184260e7b2f204a489a1c80d9a1939b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SELECTED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eacc45152c44f7cf29087c66bf17583410</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SENSITIVE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae0c53804b335dd7d55e1a3ddbe12d76f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SHOWING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea471306798894af3cd14ee19ec3aaef90</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SINGLE_LINE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eab7dc583652460e80737563afad54c48c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_STALE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea0b03f4269d42f6413c7087181b8a37c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_TRANSIENT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eabb54a2722b9b213a699f35a09195afca</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_VERTICAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eab9027e2efcc01b4aac8deb30e34fc0aa</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_VISIBLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea6aa787a91d66a1c8fea75c196febfc43</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MANAGES_DESCENDANTS</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea5895f35295aeaa7cc86de41bf7cb2517</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_INDETERMINATE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae4b19682debcbeada8e9061b033bbd22</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_TRUNCATED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead1f2cb1d7770bb2c4549ef5b998cf21c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_REQUIRED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaeea37ea980f7cb90a79eed520bc635e5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_INVALID_ENTRY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead23e93d50443d9192b13fc22aae4487a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SUPPORTS_AUTOCOMPLETION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea728f19b8503f125626d40de2694eda0f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SELECTABLE_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eafbd1e0653faaedf8c0f2195155c53a71</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_DEFAULT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae6515e887af6dba27f3440f4077246a6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ANIMATED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae1676a444f17d437c39d2ea259bb0b30</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_VISITED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea4250cdc6e143fa21ffb33f5393b5d60b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_CHECKABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea7d7bf124cb47822589dbde80870b7b27</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_HAS_POPUP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea791201a6f5afbb03e45201a659051265</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_HAS_TOOLTIP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea459fd9dbe770234f46622b1a69171588</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_READ_ONLY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead4b696e61543f7a90b38237b1437efc1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_LAST_DEFINED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea65bb8311dba662b7de5ca0fc6ab4ffe4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>BuiltinTextAttribute</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_INVALID</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca6623d891e6bd2208c9eefd24818fd607</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_LEFT_MARGIN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca2b960ba196c7b30805302a5eb8e68c67</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_RIGHT_MARGIN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca90a6fc151df2620a05ffd9e6b11a14f6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_INDENT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca7e2423b00c02750ec2e9bf3bb2a2746b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_INVISIBLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca6a62c8d4ed9e0b3576781f0bf438600b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_EDITABLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca686a97eac5e7b2441b9d135eaa8aedd9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_PIXELS_ABOVE_LINES</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca25f48005c0ca8297fa1af4cf0a93004b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_PIXELS_BELOW_LINES</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cac138d55030e45b2f69988c22c2e59dd6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_PIXELS_INSIDE_WRAP</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca01fc024ae13e08378337ee5706a05c2c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_BG_FULL_HEIGHT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cadd0551cc3e6eb5f8a7d92715e1abbc1a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_RISE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca07e54f14a00a3eee2ef2673e9c2c76d0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_UNDERLINE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca0bc049631db42b5d8592517d7808eeb1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_STRIKETHROUGH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cab48dfe09328fa8944e100265a607bf97</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_SIZE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca4ccfa24b0cd1e7606d3efa12e83c43a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_SCALE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cac419a4005306997b96d132f97677e155</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_WEIGHT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca65ff75007b1066c6db020eda58fef272</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_LANGUAGE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca9806ae08818a64eb9b0a40d102229365</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_FAMILY_NAME</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca35b3400077ff53359e96eaaa237434f0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_BG_COLOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca5fd2c74fdd6398aef3a9ef6cd72a9ee3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_FG_COLOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca506f4979837e29ac43cd8260e5847f15</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_BG_STIPPLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca81533acc5938e4457a9321362b640d1f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_FG_STIPPLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caccbd21662832e81f410f32e3651b4cd2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_WRAP_MODE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca7dc78afcf3ee43e478994e2d8e6aefa5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_DIRECTION</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca6f45667975ba8eea4816f669136365f5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_JUSTIFICATION</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caa8a04cd3c92075079045b4a1c6052f81</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_STRETCH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca4af53be9eb1140dfb427727811799f42</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_VARIANT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cae216ca5822aaa755c0d1b9e8783200ee</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_STYLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caf4302d1b05ef86d456d9eaf72455490b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_LAST_DEFINED</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caa9b6ba53580dc243040d4089cbe25b6c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TextBoundary</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_CHAR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5baa9d3c2bb0b1bff614d192bf1ed511dff</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_WORD_START</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba5ba2088bb55054a4174b592a97d41eda</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_WORD_END</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba86ac904b652515f20264f9303e4f368c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_SENTENCE_START</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba15fd2598f02f559dd94740177fdda0f1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_SENTENCE_END</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba17b884b049388ee37e2a69935f909f1e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_LINE_START</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5bae63453a52227ecbc0e9b77ce1e93b1b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_LINE_END</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba4d06f3a051104a36c6f81e47c79220b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TextClipType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_NONE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102acd3a8a23ccb6e486855b6853c6bf4d16</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_MIN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102a762a6ea026e37dd76fc600156ce3f32c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_MAX</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102a9323a443fd8fd1d053e7e9eceef49c31</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_BOTH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102a381a32f59dd65a5dc8338990a1ada36d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TextGranularity</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157ac</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_CHAR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157aca053c97eb7d13c76c54e081cfe2bcdc41</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_WORD</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157aca56f7354a85f01443476596b29dc94800</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_SENTENCE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157acab4ecfefd5237e4d4147f399d391d35ad</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_LINE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157acaf639e9ee84883727da0ea0ec19a670ed</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_PARAGRAPH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157acaaae88db1a99725557feee9364023655d</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>init</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>a29ec8cc19a1bc9fcd00565da12583e1e</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>Glib</name>
    <filename>namespaceGlib.html</filename>
    <member kind="typedef">
      <type>ArrayHandle&lt; Glib::ustring &gt;</type>
      <name>StringArrayHandle</name>
      <anchorfile>group__ContHandles.html</anchorfile>
      <anchor>ga66b4a4b57f64be3fdc1972d8bf93723a</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>Glib::ArrayHandle&lt; Glib::ustring &gt;</type>
      <name>SArray</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a5be457e99a6774e61acfe8f7d20f12b1</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxy&lt; R &gt;</type>
      <name>SignalProxy0</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a155737cae7f7b06b2b7f2f63998bd4fb</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxy&lt; R, T1 &gt;</type>
      <name>SignalProxy1</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a51901f16f9c1b820b285a93919eff6d2</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxy&lt; R, T1, T2 &gt;</type>
      <name>SignalProxy2</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a2d7df8f788171725eb6667be8b0109ca</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxy&lt; R, T1, T2, T3 &gt;</type>
      <name>SignalProxy3</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>abe36304b876f34c10e2a3354611b8677</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxy&lt; R, T1, T2, T3, T4 &gt;</type>
      <name>SignalProxy4</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a02e24f53a767dfb69d0ef3ff6b26eb80</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxy&lt; R, T1, T2, T3, T4, T5 &gt;</type>
      <name>SignalProxy5</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a4881f09b5aec85e9eb038eb265f4503d</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxy&lt; R, T1, T2, T3, T4, T5, T6 &gt;</type>
      <name>SignalProxy6</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a4573dbf960fcbed7f8dc332603031f2a</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxyDetailedAnyType&lt; R &gt;</type>
      <name>SignalProxyDetailed0</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>aae7c7e7367ead24e78181bda1bfb3744</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxyDetailedAnyType&lt; R, T1 &gt;</type>
      <name>SignalProxyDetailed1</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a54274aad465ea5f4a2467cfed8643d4c</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxyDetailedAnyType&lt; R, T1, T2 &gt;</type>
      <name>SignalProxyDetailed2</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a49dfa86dde89998bf1fb28a6718d78a9</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxyDetailedAnyType&lt; R, T1, T2, T3 &gt;</type>
      <name>SignalProxyDetailed3</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a7133f945344c7d8b66f470492c99203a</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxyDetailedAnyType&lt; R, T1, T2, T3, T4 &gt;</type>
      <name>SignalProxyDetailed4</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ad147a64bf10558f8382b9b142f08ed3a</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxyDetailedAnyType&lt; R, T1, T2, T3, T4, T5 &gt;</type>
      <name>SignalProxyDetailed5</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ae0bb2b218bc899c7711458ab8a55b0e0</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SignalProxyDetailedAnyType&lt; R, T1, T2, T3, T4, T5, T6 &gt;</type>
      <name>SignalProxyDetailed6</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a6a647516fa7ce3e8d6c3cc1da497b8ee</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>GTimeSpan</type>
      <name>TimeSpan</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a3f11fead09a7e393e8e6b345a1b7b1c1</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>GPid</type>
      <name>Pid</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a78044275242a0c3535e3b7b860106c0b</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>sigc::slot&lt; void &gt;</type>
      <name>SlotSpawnChildSetup</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>ga3bac87a2607d06097afbcd5ebae5d57a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>OwnershipType</name>
      <anchorfile>group__ContHandles.html</anchorfile>
      <anchor>ga64c27560b41710ccf64a3679a3ba3f20</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>BindingFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga6af48352fc6ed053e5ebebfe02630a6f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ParamFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbc</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>FileTest</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga33c24ccefbd130021f06708763e16ef2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>SeekType</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaa3767731311bdba4ef42dc99215e5cda</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>IOStatus</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga23fb251e48485b62a9c2677bb1f87d5e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>IOFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>IOCondition</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gabd96381793b70d4ae32c725926990918</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>KeyFileFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga5866be36312563d91e5a7be27348459b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>UserDirectory</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>FormatSizeFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga53f0c2b27f8ba1bca1e695397a75c673</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ModuleFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga502283ffbe523adf38c69905ec8640f3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TraverseType</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gae3a70fa1e451da068323419e8c98e9a9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>RegexCompileFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>RegexMatchFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>SpawnFlags</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dd</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ThreadPriority</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga9b87dca6496b6ad53baec9ca01318448</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>NotLock</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a2dd111336e3b057b51ca5871795fffa4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TryLock</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a7441a36336ea4cdb35c0fddbf3f97b19</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TimeType</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga56a2fdf6fb8599b99302868a176aac43</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>UnicodeType</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>UnicodeBreakType</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0ea</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>AsciiType</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga2e5a690ed07dfaa6f9ad9f1c57acd787</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>NormalizeMode</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>Sequence&lt; Iterator &gt;</type>
      <name>sequence</name>
      <anchorfile>group__ContHandles.html</anchorfile>
      <anchor>ga76f58aa143a15c1ba422846c3176fbdc</anchor>
      <arglist>(Iterator pbegin, Iterator pend)</arglist>
    </member>
    <member kind="function">
      <type>sigc::connection</type>
      <name>add_exception_handler</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a9a79a59cac511993cfea861bebd2f391</anchor>
      <arglist>(const sigc::slot&lt; void &gt; &amp;slot)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>init</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ac90aee10d0b90e3d8a96a86b5394f87b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>RefPtr&lt; ObjectBase &gt;</type>
      <name>wrap_interface</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a75643fed688d354848a0379d3da00133</anchor>
      <arglist>(GObject *object, bool take_copy=false)</arglist>
    </member>
    <member kind="function">
      <type>SignalTimeout</type>
      <name>signal_timeout</name>
      <anchorfile>group__MainLoop.html</anchorfile>
      <anchor>gaadb206fcc112f086f9d47c016b1f2175</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>SignalIdle</type>
      <name>signal_idle</name>
      <anchorfile>group__MainLoop.html</anchorfile>
      <anchor>ga76792522d9680a05e232d3519a25f98d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>SignalIO</type>
      <name>signal_io</name>
      <anchorfile>group__MainLoop.html</anchorfile>
      <anchor>gaf391654b755a32169d18be4835677376</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>SignalChildWatch</type>
      <name>signal_child_watch</name>
      <anchorfile>group__MainLoop.html</anchorfile>
      <anchor>ga11ee7db80cc44ece02056a38bb049e3b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>str_has_prefix</name>
      <anchorfile>group__StringUtils.html</anchorfile>
      <anchor>ga6b7e8354049756e92a97554a107618ac</anchor>
      <arglist>(const std::string &amp;str, const std::string &amp;prefix)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>str_has_suffix</name>
      <anchorfile>group__StringUtils.html</anchorfile>
      <anchor>ga5c4e380ffc6617ac61ca92e203e45630</anchor>
      <arglist>(const std::string &amp;str, const std::string &amp;suffix)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>strescape</name>
      <anchorfile>group__StringUtils.html</anchorfile>
      <anchor>ga35e288b5ce34cb15eeec907421d2b77c</anchor>
      <arglist>(const std::string &amp;source)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>strescape</name>
      <anchorfile>group__StringUtils.html</anchorfile>
      <anchor>gad24f3547c8d6b3ec56d7f5805a11d6ab</anchor>
      <arglist>(const std::string &amp;source, const std::string &amp;exceptions)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>strcompress</name>
      <anchorfile>group__StringUtils.html</anchorfile>
      <anchor>ga85cd83bd40baf0119aac3ff0a9a5e7b2</anchor>
      <arglist>(const std::string &amp;source)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>strerror</name>
      <anchorfile>group__StringUtils.html</anchorfile>
      <anchor>ga1eb869894996c91c0f69dbff96714c71</anchor>
      <arglist>(int errnum)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>strsignal</name>
      <anchorfile>group__StringUtils.html</anchorfile>
      <anchor>ga44ce9f689aff8abe1e3073b209f360d3</anchor>
      <arglist>(int signum)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>usleep</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a5d75264c8b47f13fb33f973b0d4fc73e</anchor>
      <arglist>(unsigned long microseconds)</arglist>
    </member>
    <member kind="function">
      <type>gunichar</type>
      <name>get_unichar_from_std_iterator</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a1053052aad41d0dcf51f36c345bf4625</anchor>
      <arglist>(std::string::const_iterator pos)</arglist>
    </member>
    <member kind="function">
      <type>T::BaseObjectType *</type>
      <name>unwrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a2f73967c03d89b0bd6f730f6c36f748d</anchor>
      <arglist>(T *ptr)</arglist>
    </member>
    <member kind="function">
      <type>const T::BaseObjectType *</type>
      <name>unwrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a9841353e0b6ffe28fd74abe40c4d005d</anchor>
      <arglist>(const T *ptr)</arglist>
    </member>
    <member kind="function">
      <type>T::BaseObjectType *</type>
      <name>unwrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ac72231155b9573af4b4d5e6ce6494620</anchor>
      <arglist>(const Glib::RefPtr&lt; T &gt; &amp;ptr)</arglist>
    </member>
    <member kind="function">
      <type>const T::BaseObjectType *</type>
      <name>unwrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ad806817113ad836cdd8ef5e3913316ab</anchor>
      <arglist>(const Glib::RefPtr&lt; const T &gt; &amp;ptr)</arglist>
    </member>
    <member kind="function">
      <type>T::BaseObjectType *</type>
      <name>unwrap_copy</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a4e505dac0cb5b57703424cb12fa5a84f</anchor>
      <arglist>(const T &amp;obj)</arglist>
    </member>
    <member kind="function">
      <type>T::BaseObjectType *</type>
      <name>unwrap_copy</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a10a4206b41c1c361c29750d76924a752</anchor>
      <arglist>(const Glib::RefPtr&lt; T &gt; &amp;ptr)</arglist>
    </member>
    <member kind="function">
      <type>const T::BaseObjectType *</type>
      <name>unwrap_copy</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a2792c33cdf2e70d10e432c6cf0fcac76</anchor>
      <arglist>(const Glib::RefPtr&lt; const T &gt; &amp;ptr)</arglist>
    </member>
    <member kind="function">
      <type>BindingFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga749e95d7cc7706529af4346d2cf93dbe</anchor>
      <arglist>(BindingFlags lhs, BindingFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>BindingFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga3c657041e3f9755edcd90d0f0ca2352e</anchor>
      <arglist>(BindingFlags lhs, BindingFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>BindingFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga0fc30bce2b354d907971c0bf0e4d2f2e</anchor>
      <arglist>(BindingFlags lhs, BindingFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>BindingFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga67a0e7f1c6cc4b071674d8026d562dc4</anchor>
      <arglist>(BindingFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>BindingFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga780a6b8d58daa1d6167da8f1b715d372</anchor>
      <arglist>(BindingFlags &amp;lhs, BindingFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>BindingFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga0ea6363e1a9dc48a70f451f2be87bc43</anchor>
      <arglist>(BindingFlags &amp;lhs, BindingFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>BindingFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaa52d6f01bc09aaeab3dd1a8afa4e9b57</anchor>
      <arglist>(BindingFlags &amp;lhs, BindingFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>get_charset</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gabf5fac564c47a7a9ad6037044c3909f4</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>get_charset</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>ga88965337df48a173a6b013e8243e4631</anchor>
      <arglist>(std::string &amp;charset)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>convert</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>ga58f7e4556c436a96c64b186bbc8f7f4c</anchor>
      <arglist>(const std::string &amp;str, const std::string &amp;to_codeset, const std::string &amp;from_codeset)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>convert_with_fallback</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>ga40b5aa172fabd1f3dbf50a962d0d351f</anchor>
      <arglist>(const std::string &amp;str, const std::string &amp;to_codeset, const std::string &amp;from_codeset)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>convert_with_fallback</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gaf1b091e4397a7637e884148484b1f71e</anchor>
      <arglist>(const std::string &amp;str, const std::string &amp;to_codeset, const std::string &amp;from_codeset, const Glib::ustring &amp;fallback)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>locale_to_utf8</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>ga4517b17f2aad4cd5c0e0640de212d928</anchor>
      <arglist>(const std::string &amp;opsys_string)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>locale_from_utf8</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gacc062729285890a7e9b22bece6fb987c</anchor>
      <arglist>(const Glib::ustring &amp;utf8_string)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>filename_to_utf8</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>ga6cf95dc00505401594260a360d70c17b</anchor>
      <arglist>(const std::string &amp;opsys_string)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>filename_from_utf8</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>ga2bd94064ad97b43324a7854b62f0835b</anchor>
      <arglist>(const Glib::ustring &amp;utf8_string)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>filename_from_uri</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gada23cd7f7dc8eb25e99b867a55551763</anchor>
      <arglist>(const Glib::ustring &amp;uri, Glib::ustring &amp;hostname)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>filename_from_uri</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gab1cb94f4a4a70bad06b715fb14a252d9</anchor>
      <arglist>(const Glib::ustring &amp;uri)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>filename_to_uri</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gae1b2f056bde3fbab578c602fe42e3de9</anchor>
      <arglist>(const std::string &amp;filename, const Glib::ustring &amp;hostname)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>filename_to_uri</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gaaf69aec83665229cc06596cf627d9d5a</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>filename_display_basename</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>ga05dd67157ad35da4401263247b6f4d81</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>filename_display_name</name>
      <anchorfile>group__CharsetConv.html</anchorfile>
      <anchor>gabc1b404cc965f3da6beecddfe2623afc</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>ParamFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga64411a0c48e2c3ecbc40926275201071</anchor>
      <arglist>(ParamFlags lhs, ParamFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ParamFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga01328dbced7d009330fe01cf8334ae7f</anchor>
      <arglist>(ParamFlags lhs, ParamFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ParamFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga23118c9638ef338fb3cb06407099fb17</anchor>
      <arglist>(ParamFlags lhs, ParamFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ParamFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaaea9028c5269446e3e892216fc7e9f09</anchor>
      <arglist>(ParamFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>ParamFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga4180c1b9f616ce95a2fdf066360796a5</anchor>
      <arglist>(ParamFlags &amp;lhs, ParamFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ParamFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaad68b971795db0bf683a37b7962244dd</anchor>
      <arglist>(ParamFlags &amp;lhs, ParamFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ParamFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaf07dad32ab115f4f1db890ed19d50220</anchor>
      <arglist>(ParamFlags &amp;lhs, ParamFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>FileTest</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga8e018d8609ba17b0f6955505a8363bf7</anchor>
      <arglist>(FileTest lhs, FileTest rhs)</arglist>
    </member>
    <member kind="function">
      <type>FileTest</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gae652f47e7b61603b9a6b86b7251d5526</anchor>
      <arglist>(FileTest lhs, FileTest rhs)</arglist>
    </member>
    <member kind="function">
      <type>FileTest</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga6c089f23d6bfd92e083edc75519db75e</anchor>
      <arglist>(FileTest lhs, FileTest rhs)</arglist>
    </member>
    <member kind="function">
      <type>FileTest</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga948edadd8ee7442b83d37dc3c325f890</anchor>
      <arglist>(FileTest flags)</arglist>
    </member>
    <member kind="function">
      <type>FileTest &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga9a6f5470f667596e897f5bfbd1068283</anchor>
      <arglist>(FileTest &amp;lhs, FileTest rhs)</arglist>
    </member>
    <member kind="function">
      <type>FileTest &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga112ada474a7aad83af2bd49403abf41e</anchor>
      <arglist>(FileTest &amp;lhs, FileTest rhs)</arglist>
    </member>
    <member kind="function">
      <type>FileTest &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga2219c78993a5196ca2a435a18e0fc3a7</anchor>
      <arglist>(FileTest &amp;lhs, FileTest rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>file_test</name>
      <anchorfile>group__FileUtils.html</anchorfile>
      <anchor>ga0b2fce78896a9a84f7ea3a5646cc7d36</anchor>
      <arglist>(const std::string &amp;filename, FileTest test)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>mkstemp</name>
      <anchorfile>group__FileUtils.html</anchorfile>
      <anchor>gae4c8d716bd109b6b8e1420a8c20b3507</anchor>
      <arglist>(std::string &amp;filename_template)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>file_open_tmp</name>
      <anchorfile>group__FileUtils.html</anchorfile>
      <anchor>gae91f239f1cf0123399374deed54fbf3a</anchor>
      <arglist>(std::string &amp;name_used, const std::string &amp;prefix)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>file_open_tmp</name>
      <anchorfile>group__FileUtils.html</anchorfile>
      <anchor>ga682379de4ea119540b4bdc1759e93e1d</anchor>
      <arglist>(std::string &amp;name_used)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>file_get_contents</name>
      <anchorfile>group__FileUtils.html</anchorfile>
      <anchor>ga835da54212fe78e833ac55b49150b989</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>file_set_contents</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a4c6c4cb2115f410b15f09634909b0b7c</anchor>
      <arglist>(const std::string &amp;filename, const gchar *contents, gssize length)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>file_set_contents</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a3e51edee26822f97749f589138776850</anchor>
      <arglist>(const std::string &amp;filename, const std::string &amp;contents)</arglist>
    </member>
    <member kind="function">
      <type>IOFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga0dd0a8800b6311ee8f3867eb27a72ae5</anchor>
      <arglist>(IOFlags lhs, IOFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga7662618e73d046d4df5eb7cce3e487f8</anchor>
      <arglist>(IOFlags lhs, IOFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gad61c57b0678c703e8a14230d18bacff7</anchor>
      <arglist>(IOFlags lhs, IOFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga548c1cb09208fef57e5d0b3c992d71b9</anchor>
      <arglist>(IOFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>IOFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gac3539f6df5e0c0658726f4f0573146f9</anchor>
      <arglist>(IOFlags &amp;lhs, IOFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gae84d9361a6154e6b0e8d099705ad6cad</anchor>
      <arglist>(IOFlags &amp;lhs, IOFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga2180a5c566ced37bbeb37050d9632da9</anchor>
      <arglist>(IOFlags &amp;lhs, IOFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOCondition</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gab5937e9164f36f75ba87fd67903348d5</anchor>
      <arglist>(IOCondition lhs, IOCondition rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOCondition</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga12928ddba0f38406f19d55547bac552b</anchor>
      <arglist>(IOCondition lhs, IOCondition rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOCondition</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga6416bbf923045261beb85241fff8ef0d</anchor>
      <arglist>(IOCondition lhs, IOCondition rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOCondition</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga85461947d24f306cefd2fe17999deb97</anchor>
      <arglist>(IOCondition flags)</arglist>
    </member>
    <member kind="function">
      <type>IOCondition &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga8269a01826f8737d98ab0d345a0004f4</anchor>
      <arglist>(IOCondition &amp;lhs, IOCondition rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOCondition &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga11f46ad6051058eeeb34d5963a4f7c44</anchor>
      <arglist>(IOCondition &amp;lhs, IOCondition rhs)</arglist>
    </member>
    <member kind="function">
      <type>IOCondition &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga995d6d5d01db67af62661bcd5dfd1ad6</anchor>
      <arglist>(IOCondition &amp;lhs, IOCondition rhs)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; IOChannel &gt;</type>
      <name>wrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a671306f4a3a0cae5ab4d7a9d54886592</anchor>
      <arglist>(GIOChannel *gobject, bool take_copy=false)</arglist>
    </member>
    <member kind="function">
      <type>KeyFileFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gabac5e1493392116b118e4d1048e3fef0</anchor>
      <arglist>(KeyFileFlags lhs, KeyFileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>KeyFileFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga1827ef58fe5e85d65ff8166e51b33556</anchor>
      <arglist>(KeyFileFlags lhs, KeyFileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>KeyFileFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gacc28b21831114895abfdbae6c1908114</anchor>
      <arglist>(KeyFileFlags lhs, KeyFileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>KeyFileFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gab99ff1d7c6d96da2ddfcfd1c4954e9b6</anchor>
      <arglist>(KeyFileFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>KeyFileFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga7096a34594825c90d7b6257935a62eb1</anchor>
      <arglist>(KeyFileFlags &amp;lhs, KeyFileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>KeyFileFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga80dd56fcaea8bc3f0a5f21b9d3049877</anchor>
      <arglist>(KeyFileFlags &amp;lhs, KeyFileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>KeyFileFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gac90869f74a743e2f99f55708c28a585d</anchor>
      <arglist>(KeyFileFlags &amp;lhs, KeyFileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>FormatSizeFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga55c3ed59e5e0f11fe51ae823c9ebd8c5</anchor>
      <arglist>(FormatSizeFlags lhs, FormatSizeFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>FormatSizeFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga53ee4c03a17351cf3eeee91ad0851084</anchor>
      <arglist>(FormatSizeFlags lhs, FormatSizeFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>FormatSizeFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gac1a95f6b60212d09d58f2d5f79c2ed55</anchor>
      <arglist>(FormatSizeFlags lhs, FormatSizeFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>FormatSizeFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga0ae9e277d1b96ba75f89aad2c449951a</anchor>
      <arglist>(FormatSizeFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>FormatSizeFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gad0242df3176de300921be12195b30066</anchor>
      <arglist>(FormatSizeFlags &amp;lhs, FormatSizeFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>FormatSizeFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gac415899f08f69fdc4517b5277d36fa62</anchor>
      <arglist>(FormatSizeFlags &amp;lhs, FormatSizeFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>FormatSizeFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga472fd7f4cc0a950e7b9ec14f0d89f060</anchor>
      <arglist>(FormatSizeFlags &amp;lhs, FormatSizeFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_application_name</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga9c2f67828083d74925b23c59ab868698</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_application_name</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga40e45835b7b461cba0f7a10fbb63c0d3</anchor>
      <arglist>(const Glib::ustring &amp;application_name)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_prgname</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga391655dededb496010eee2e92d0f1fdf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_prgname</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga7d5c429822c09048892c4dee9c8e08c1</anchor>
      <arglist>(const std::string &amp;prgname)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>getenv</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga5e186fdb08835342a5866b11fe787ebb</anchor>
      <arglist>(const std::string &amp;variable, bool &amp;found)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>getenv</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga8e2c8f250aa7f059956737851ace08f6</anchor>
      <arglist>(const std::string &amp;variable)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>setenv</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga862657f21e5a930541d048a920204f59</anchor>
      <arglist>(const std::string &amp;variable, const std::string &amp;value, bool overwrite=true)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>unsetenv</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga6fb89001630714ec9ee5244cab56343e</anchor>
      <arglist>(const std::string &amp;variable)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ArrayHandle&lt; std::string &gt;</type>
      <name>listenv</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga350a5f6f1ae631f748c89d8dbe7557df</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_user_name</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga52964bfd712e8c9e688f668da51f3ed9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_real_name</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga30692e3263e66868878f535e0b7c9722</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>get_host_name</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga277934ae26423bfc8041ff8f2477a7f1</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_home_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga9412ea70c7fea058c03211dac318f8e6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_tmp_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gac42272146fd9320958132f1591d28991</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_current_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga06d93c95572d6a382b8cc4e09dd5a339</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_user_special_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gabc928a4e477df53f90e221a854cc73cb</anchor>
      <arglist>(GUserDirectory directory)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_user_special_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga33289a74049470bc23a3859ba8b310c5</anchor>
      <arglist>(UserDirectory directory)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_user_data_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga821b704b5ede1583e4057990976d394b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_user_config_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gae517b931f4753abcd48adb2769a8fc48</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; std::string &gt;</type>
      <name>get_system_data_dirs</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga3a957e23dc92b928045135d4a5c6aec9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; std::string &gt;</type>
      <name>get_system_config_dirs</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga7ac473ccb6ff59400b62b9396d1b72bd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_user_cache_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gaa68121f26e82df1c293c82b89c8998e5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_user_runtime_dir</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga446e4191b677211b7d37e703f2355330</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>path_is_absolute</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gad82525f39f7408f97f2c096c4f721b3b</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>path_skip_root</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga306eee64abc3d28993895b826f4dd533</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>path_get_basename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga20ebf2917a7fce5d1901568017b95a35</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>path_get_dirname</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gae03457226c4239a74b83486739521434</anchor>
      <arglist>(const std::string &amp;filename)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>canonicalize_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga26f7544ac2a74eb1e3351a65b638f309</anchor>
      <arglist>(StdStringView filename, StdStringView relative_to=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gaa4a70bf050b3f318f87049ed30206a9a</anchor>
      <arglist>(const Glib::ArrayHandle&lt; std::string &gt; &amp;elements)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gaf5e106ab98c5978491b6d0d9e26f6f92</anchor>
      <arglist>(const String1 &amp;elem1, const String2 &amp;elem2, const Strings &amp;...strings)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gada06023cc39be3a44eb68e38d6cbea6c</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gaf2be471b98cb5d47c9a30c084f87d9a7</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2, const std::string &amp;elem3)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gab342ab4856f3de7a5bc69a36773d7fb3</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2, const std::string &amp;elem3, const std::string &amp;elem4)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga95d2bc18e3b0974f909243aca9970476</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2, const std::string &amp;elem3, const std::string &amp;elem4, const std::string &amp;elem5)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga8b726f15e39f873bb0174d26d8a636a6</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2, const std::string &amp;elem3, const std::string &amp;elem4, const std::string &amp;elem5, const std::string &amp;elem6)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gaea9f342e6f620944625d48194622cdc6</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2, const std::string &amp;elem3, const std::string &amp;elem4, const std::string &amp;elem5, const std::string &amp;elem6, const std::string &amp;elem7)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga4349eeddfaee3e22194bc511d1e92873</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2, const std::string &amp;elem3, const std::string &amp;elem4, const std::string &amp;elem5, const std::string &amp;elem6, const std::string &amp;elem7, const std::string &amp;elem8)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_filename</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gafb17c98037af155ff8c46499bfbc5d2d</anchor>
      <arglist>(const std::string &amp;elem1, const std::string &amp;elem2, const std::string &amp;elem3, const std::string &amp;elem4, const std::string &amp;elem5, const std::string &amp;elem6, const std::string &amp;elem7, const std::string &amp;elem8, const std::string &amp;elem9)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>build_path</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga6afc89d45cc34f3cfce4a55f3f5e7afa</anchor>
      <arglist>(const std::string &amp;separator, const Glib::ArrayHandle&lt; std::string &gt; &amp;elements)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>find_program_in_path</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>gaa4c4ecb9a3eb803ae6d9dee51e1e5b14</anchor>
      <arglist>(const std::string &amp;program)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ustring</type>
      <name>format_size</name>
      <anchorfile>group__MiscUtils.html</anchorfile>
      <anchor>ga496c472c5f7234a09924eb1d30b93f44</anchor>
      <arglist>(guint64 size, FormatSizeFlags flags=FORMAT_SIZE_DEFAULT)</arglist>
    </member>
    <member kind="function">
      <type>ModuleFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gade862759d091b90329ba8f85aa2fd010</anchor>
      <arglist>(ModuleFlags lhs, ModuleFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ModuleFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaacd06c8457fa8f31c1483f96c4933ddf</anchor>
      <arglist>(ModuleFlags lhs, ModuleFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ModuleFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga333d93ef372c08c322d27ac05bda0e18</anchor>
      <arglist>(ModuleFlags lhs, ModuleFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ModuleFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaaa723a5b4d33e54167f7adbb18746004</anchor>
      <arglist>(ModuleFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>ModuleFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gae9df767ea1ec74b0d9d9acce426a07a8</anchor>
      <arglist>(ModuleFlags &amp;lhs, ModuleFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ModuleFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gab903aa5397125ce37c66a259c4b1a5f5</anchor>
      <arglist>(ModuleFlags &amp;lhs, ModuleFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>ModuleFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga8e73a634c6441630eddf8805b22dd163</anchor>
      <arglist>(ModuleFlags &amp;lhs, ModuleFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexCompileFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga5c44b3a4eee7eefbb1f2d1d8f22642ca</anchor>
      <arglist>(RegexCompileFlags lhs, RegexCompileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexCompileFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga4ae748a01d312275d2ca4e15c5df5826</anchor>
      <arglist>(RegexCompileFlags lhs, RegexCompileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexCompileFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga69068f48bbea92cdd3cc7d69fdc017e1</anchor>
      <arglist>(RegexCompileFlags lhs, RegexCompileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexCompileFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gacb650222b1a3f6a44e72df95d815a7f8</anchor>
      <arglist>(RegexCompileFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>RegexCompileFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gae6fd65d5a674d2e2e453793d86fa64cd</anchor>
      <arglist>(RegexCompileFlags &amp;lhs, RegexCompileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexCompileFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaeefcf05c20e07dde23268b83a1ff1c45</anchor>
      <arglist>(RegexCompileFlags &amp;lhs, RegexCompileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexCompileFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga1425051a4ffed939a1bff1e0543c9498</anchor>
      <arglist>(RegexCompileFlags &amp;lhs, RegexCompileFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexMatchFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gab63da3a959cbd5f00f4fa535e35eda08</anchor>
      <arglist>(RegexMatchFlags lhs, RegexMatchFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexMatchFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga29b80a6c4482fae8e19f9328ec0c3147</anchor>
      <arglist>(RegexMatchFlags lhs, RegexMatchFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexMatchFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga06c395f619dffca3f0fc483fab302122</anchor>
      <arglist>(RegexMatchFlags lhs, RegexMatchFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexMatchFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaf192ce556cbd7ddb416e8078bdb09523</anchor>
      <arglist>(RegexMatchFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>RegexMatchFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga8f30deab298559a873d7beca40279ead</anchor>
      <arglist>(RegexMatchFlags &amp;lhs, RegexMatchFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexMatchFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga283a3e82cd9d3da8746edbe13a6f616a</anchor>
      <arglist>(RegexMatchFlags &amp;lhs, RegexMatchFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>RegexMatchFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga402d81f594d95305aa6e275aa74126ae</anchor>
      <arglist>(RegexMatchFlags &amp;lhs, RegexMatchFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>Glib::ArrayHandle&lt; std::string &gt;</type>
      <name>shell_parse_argv</name>
      <anchorfile>group__ShellUtils.html</anchorfile>
      <anchor>gabc52fcb14cfc7a5ba37ca821cc837818</anchor>
      <arglist>(const std::string &amp;command_line)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>shell_quote</name>
      <anchorfile>group__ShellUtils.html</anchorfile>
      <anchor>ga55ebfb935f2131b2ae40d339568f568c</anchor>
      <arglist>(const std::string &amp;unquoted_string)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>shell_unquote</name>
      <anchorfile>group__ShellUtils.html</anchorfile>
      <anchor>ga449dc37c6ea7e7563740df86e31c263c</anchor>
      <arglist>(const std::string &amp;quoted_string)</arglist>
    </member>
    <member kind="function">
      <type>SpawnFlags</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gaba6cac919da111ebf69667bf9f8006ff</anchor>
      <arglist>(SpawnFlags lhs, SpawnFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>SpawnFlags</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga2d10b36fdc1ceb9fea2ffcd58406f3e2</anchor>
      <arglist>(SpawnFlags lhs, SpawnFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>SpawnFlags</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga84449a9a461b381f88f65435ef8389ec</anchor>
      <arglist>(SpawnFlags lhs, SpawnFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>SpawnFlags</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga065f45ca68d1397febf331293e4cc4de</anchor>
      <arglist>(SpawnFlags flags)</arglist>
    </member>
    <member kind="function">
      <type>SpawnFlags &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gabbe289c910b34a158f8dc22bb0b0095f</anchor>
      <arglist>(SpawnFlags &amp;lhs, SpawnFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>SpawnFlags &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga93f15ab009ea244c1d8b069e27ec193f</anchor>
      <arglist>(SpawnFlags &amp;lhs, SpawnFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>SpawnFlags &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga40166fcca8eb8ec5b148c82444553927</anchor>
      <arglist>(SpawnFlags &amp;lhs, SpawnFlags rhs)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_async_with_pipes</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>ga68ea12be3693ed49e92312b63bef2d38</anchor>
      <arglist>(const std::string &amp;working_directory, const Glib::ArrayHandle&lt; std::string &gt; &amp;argv, const Glib::ArrayHandle&lt; std::string &gt; &amp;envp, SpawnFlags flags=SPAWN_DEFAULT, const SlotSpawnChildSetup &amp;child_setup=SlotSpawnChildSetup(), Pid *child_pid=nullptr, int *standard_input=nullptr, int *standard_output=nullptr, int *standard_error=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_async_with_pipes</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>ga6d494f70dd5b914102c89083f7996486</anchor>
      <arglist>(const std::string &amp;working_directory, const Glib::ArrayHandle&lt; std::string &gt; &amp;argv, SpawnFlags flags=SPAWN_DEFAULT, const SlotSpawnChildSetup &amp;child_setup=SlotSpawnChildSetup(), Pid *child_pid=nullptr, int *standard_input=nullptr, int *standard_output=nullptr, int *standard_error=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_async</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>gaa08d620227e82bccba437ecc541ef6fa</anchor>
      <arglist>(const std::string &amp;working_directory, const Glib::ArrayHandle&lt; std::string &gt; &amp;argv, const Glib::ArrayHandle&lt; std::string &gt; &amp;envp, SpawnFlags flags=SPAWN_DEFAULT, const SlotSpawnChildSetup &amp;child_setup=SlotSpawnChildSetup(), Pid *child_pid=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_async</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>gab045450852e2a4dcbdecf0887d716aa6</anchor>
      <arglist>(const std::string &amp;working_directory, const Glib::ArrayHandle&lt; std::string &gt; &amp;argv, SpawnFlags flags=SPAWN_DEFAULT, const SlotSpawnChildSetup &amp;child_setup=SlotSpawnChildSetup(), Pid *child_pid=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_sync</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>ga570555dc2fe25b548aaf528ac0127a1e</anchor>
      <arglist>(const std::string &amp;working_directory, const Glib::ArrayHandle&lt; std::string &gt; &amp;argv, const Glib::ArrayHandle&lt; std::string &gt; &amp;envp, SpawnFlags flags=SPAWN_DEFAULT, const SlotSpawnChildSetup &amp;child_setup=SlotSpawnChildSetup(), std::string *standard_output=nullptr, std::string *standard_error=nullptr, int *exit_status=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_sync</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>ga44b768c4cd7158e32980fedbb7438a6d</anchor>
      <arglist>(const std::string &amp;working_directory, const Glib::ArrayHandle&lt; std::string &gt; &amp;argv, SpawnFlags flags=SPAWN_DEFAULT, const SlotSpawnChildSetup &amp;child_setup=SlotSpawnChildSetup(), std::string *standard_output=nullptr, std::string *standard_error=nullptr, int *exit_status=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_command_line_async</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>ga648167a4af607f87763f1334fe5a472f</anchor>
      <arglist>(const std::string &amp;command_line)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_command_line_sync</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>ga75961831b4dd3979bb8ab508ee3b3de7</anchor>
      <arglist>(const std::string &amp;command_line, std::string *standard_output=nullptr, std::string *standard_error=nullptr, int *exit_status=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>spawn_close_pid</name>
      <anchorfile>group__Spawn.html</anchorfile>
      <anchor>gaaea8f41c7a08af3b2919ce64fd0c27e5</anchor>
      <arglist>(Pid pid)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>thread_init</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a8e983bffd7c8cdbbbe6038fc5e6fd3cf</anchor>
      <arglist>(GThreadFunctions *vtable=nullptr)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>thread_supported</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ad59d126f6197035e6f6a31e7f4d87818</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>AsciiType</type>
      <name>operator|</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga5bc1518eb5547dbb8af77b944ccaa048</anchor>
      <arglist>(AsciiType lhs, AsciiType rhs)</arglist>
    </member>
    <member kind="function">
      <type>AsciiType</type>
      <name>operator&amp;</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga4c340e00aeb13a9124081f383283eed0</anchor>
      <arglist>(AsciiType lhs, AsciiType rhs)</arglist>
    </member>
    <member kind="function">
      <type>AsciiType</type>
      <name>operator^</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga682a545ca2e86b3e162305e4f14fa8d5</anchor>
      <arglist>(AsciiType lhs, AsciiType rhs)</arglist>
    </member>
    <member kind="function">
      <type>AsciiType</type>
      <name>operator~</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gad7ea47582094c6d092a8f485e1e709c6</anchor>
      <arglist>(AsciiType flags)</arglist>
    </member>
    <member kind="function">
      <type>AsciiType &amp;</type>
      <name>operator|=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga69bba23f4c9a83c268d0599f241b8ebe</anchor>
      <arglist>(AsciiType &amp;lhs, AsciiType rhs)</arglist>
    </member>
    <member kind="function">
      <type>AsciiType &amp;</type>
      <name>operator&amp;=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ga8f4b46bf548b21ef21a568ecc18a5871</anchor>
      <arglist>(AsciiType &amp;lhs, AsciiType rhs)</arglist>
    </member>
    <member kind="function">
      <type>AsciiType &amp;</type>
      <name>operator^=</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gac1b0239e539cf250333fe0adc04dbb41</anchor>
      <arglist>(AsciiType &amp;lhs, AsciiType rhs)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>uri_unescape_string</name>
      <anchorfile>group__UriUtils.html</anchorfile>
      <anchor>ga0c070cac984dc463fd60ccbdb4237e25</anchor>
      <arglist>(const std::string &amp;escaped_string, const std::string &amp;illegal_characters=std::string())</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>uri_parse_scheme</name>
      <anchorfile>group__UriUtils.html</anchorfile>
      <anchor>ga0cc4270d6796b2166964f08a5cb746b3</anchor>
      <arglist>(const std::string &amp;uri)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>uri_escape_string</name>
      <anchorfile>group__UriUtils.html</anchorfile>
      <anchor>gad902095ab5049111caa9207770b0a437</anchor>
      <arglist>(const std::string &amp;unescaped, const std::string &amp;reserved_chars_allowed=std::string(), bool allow_utf8=true)</arglist>
    </member>
    <member kind="function">
      <type>Variant&lt; Glib::ustring &gt;</type>
      <name>VariantBase::cast_dynamic&lt; Variant&lt; Glib::ustring &gt; &gt;</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a807ef11423a04d9f22d6d045fbaed27a</anchor>
      <arglist>(const VariantBase &amp;v)</arglist>
    </member>
    <member kind="function">
      <type>Variant&lt; std::string &gt;</type>
      <name>VariantBase::cast_dynamic&lt; Variant&lt; std::string &gt; &gt;</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>af44bc8b008e33a7ad5804c9a50226562</anchor>
      <arglist>(const VariantBase &amp;v)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Gio::Drive &gt;</type>
      <name>wrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a3c4b3f9afbb1f72fcd0db0fb9d96a23e</anchor>
      <arglist>(GDrive *object, bool take_copy)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Gio::File &gt;</type>
      <name>wrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>aa536133405cc52c5887f4b87879e3bd6</anchor>
      <arglist>(GFile *object, bool take_copy)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Gio::Mount &gt;</type>
      <name>wrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>aecec41aa86f5a57489c23f367593802c</anchor>
      <arglist>(GMount *object, bool take_copy)</arglist>
    </member>
    <member kind="function">
      <type>Glib::RefPtr&lt; Gio::Volume &gt;</type>
      <name>wrap</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>aa4ad6dff9c5f095f3b45b6af8124c883</anchor>
      <arglist>(GVolume *object, bool take_copy)</arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>OWNERSHIP_NONE</name>
      <anchorfile>group__ContHandles.html</anchorfile>
      <anchor>gga64c27560b41710ccf64a3679a3ba3f20a7d594cffcc2d2d6c4313ddb4d6613c79</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>OWNERSHIP_SHALLOW</name>
      <anchorfile>group__ContHandles.html</anchorfile>
      <anchor>gga64c27560b41710ccf64a3679a3ba3f20a448c598cdc37e2de8a162e1020001715</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>OWNERSHIP_DEEP</name>
      <anchorfile>group__ContHandles.html</anchorfile>
      <anchor>gga64c27560b41710ccf64a3679a3ba3f20a2a6d6bfadc36f9eda31af79d32928c6a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PRIORITY_HIGH</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a0c450f82b9e34689e2dda2038ba7834faa3219d7be6fa3282a80d7a850c401db9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PRIORITY_DEFAULT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a0c450f82b9e34689e2dda2038ba7834fa597ed3aa6067516c9c752896f3816b5e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PRIORITY_HIGH_IDLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a0c450f82b9e34689e2dda2038ba7834faf2d20696a8afab425c00268d981e9897</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PRIORITY_DEFAULT_IDLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a0c450f82b9e34689e2dda2038ba7834fae8c1127af0a2dab71f196a957dab8375</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PRIORITY_LOW</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a0c450f82b9e34689e2dda2038ba7834fac6034649b50f9f92a69c1e67b92ecfc8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>BINDING_DEFAULT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga6af48352fc6ed053e5ebebfe02630a6fa429c481acc1ddaca5c09e6d84f7dae29</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>BINDING_BIDIRECTIONAL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga6af48352fc6ed053e5ebebfe02630a6fa0c2d9e60dc3177e8dd56f36e275b3327</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>BINDING_SYNC_CREATE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga6af48352fc6ed053e5ebebfe02630a6fac39d6aa495608453a377af413fb7e9b4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>BINDING_INVERT_BOOLEAN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga6af48352fc6ed053e5ebebfe02630a6faf5440a686da1abfc17d17cb1071f008c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_READABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbca8e86b397b1d896933f70bf78427dbc79</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_WRITABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbcae586772dc00a2c781f504fdc4701846f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_READWRITE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbcad1554dc8f8eecab55f7c30e23ac391b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_CONSTRUCT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbcaa9e37000824a21f417101c94c37b2adb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_CONSTRUCT_ONLY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbcabc569cdee078f113f586999cd391f5d7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_LAX_VALIDATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbca4c7e3a69c2d5e8e8419e912eb434e0e8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_STATIC_NAME</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbcaea9c4dec23c8bbac14eaa8577e338551</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_PRIVATE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbcabc996f6a17c5aef47bcd8b0de7c2ea81</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_STATIC_NICK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbca5994d69d3d72b93e77536b5a531bd142</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_STATIC_BLURB</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbca703a97fea00613c8ddbd4211c4ed24df</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_EXPLICIT_NOTIFY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbca3dd3566586228c77257e6410386fa8c4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>PARAM_DEPRECATED</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga795b9718605425a03f337e0b7421fcbca586e2c999d0a2560e1804da0b36ab7ca</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FILE_TEST_IS_REGULAR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga33c24ccefbd130021f06708763e16ef2ad7bb008269376841fe11c05da9c01a55</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FILE_TEST_IS_SYMLINK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga33c24ccefbd130021f06708763e16ef2ae9fcdfcc6fc6ee7bb83ce9634e5e9f18</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FILE_TEST_IS_DIR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga33c24ccefbd130021f06708763e16ef2ae4072d5338587b51642d1a68c730ec19</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FILE_TEST_IS_EXECUTABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga33c24ccefbd130021f06708763e16ef2ae236ad1999c8c106a5ff31154ebd5692</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FILE_TEST_EXISTS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga33c24ccefbd130021f06708763e16ef2aa6cf22c3904f707c94f2ad911b5df6fd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SEEK_TYPE_CUR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaa3767731311bdba4ef42dc99215e5cdaac0fc030f79f4b5623de9867333011e30</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SEEK_TYPE_SET</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaa3767731311bdba4ef42dc99215e5cdaaa8e02688f42163a11bb8b47a72456bc4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SEEK_TYPE_END</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaa3767731311bdba4ef42dc99215e5cdaa615f7b38be2cbd60fe5fbebd656f38bd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_STATUS_ERROR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga23fb251e48485b62a9c2677bb1f87d5eabf1fa62d0111ab895ecb887ce6cce1c4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_STATUS_NORMAL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga23fb251e48485b62a9c2677bb1f87d5eaf2008e64a9691fc76ad9320baef5c8ba</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_STATUS_EOF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga23fb251e48485b62a9c2677bb1f87d5ea63be2a355cd7187f9ccdd854c80fd10c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_STATUS_AGAIN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga23fb251e48485b62a9c2677bb1f87d5ead240a3a0fd203dd76e11b76a8115d881</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_APPEND</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a0eddd66348cb8ec7aceef67736d59cce</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_NONBLOCK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a1a71350ea4fc4f9779a3a884f6977269</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_IS_READABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a45c527b36c1a1df9b5b1202f84eafeed</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_IS_WRITABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a0632918f94e302c0b20e722e941ad124</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_IS_WRITEABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7ac8bc4ce7e268189488cb98c94e15ce66</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_IS_SEEKABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a65e5b54c7fad833478ed9cc169cc15be</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_MASK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a26bca9503544a0e4388041812e3ea1e7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_GET_MASK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a06c9ef83e6adc8a4b4ea98dd396e2206</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_FLAG_SET_MASK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaee093e5db5bc1ea5738771ba0d1af3b7a31bd353961673e2199474810e2ff3ff0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_IN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gabd96381793b70d4ae32c725926990918aa38ee764d957d52ccd85688c27778daf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_OUT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gabd96381793b70d4ae32c725926990918a0945b81e85eb8d2d26e77fdc04821cae</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_PRI</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gabd96381793b70d4ae32c725926990918ac8998d8c99453ea30c1ba129f89ec5a0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_ERR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gabd96381793b70d4ae32c725926990918a1798f7312c98ff12681ed93f1b08f0d7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_HUP</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gabd96381793b70d4ae32c725926990918aa290fc1a996ead6c153515d4771fcdb1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>IO_NVAL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gabd96381793b70d4ae32c725926990918aadf52e698f361e79b53f0bcb3266df24</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>KEY_FILE_NONE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga5866be36312563d91e5a7be27348459baec458bae700a8dfd34898a5ab5b22d3b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>KEY_FILE_KEEP_COMMENTS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga5866be36312563d91e5a7be27348459ba27ebf6c0c9a771f0268f7b06fe7e0347</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>KEY_FILE_KEEP_TRANSLATIONS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga5866be36312563d91e5a7be27348459ba498ea5abdc02d9a60db9a0d2873f5c58</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_DESKTOP</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819a9bdde992722bfa20afe0533273f82bd9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_DOCUMENTS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819a3550469cfb212ed889b1106750495040</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_DOWNLOAD</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819aaf0c0361b86fd7c7e5cbf8015632bcd9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_MUSIC</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819a5b8e18721d39fbb45fbf965088170ca8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_PICTURES</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819a2623f44d7b841e7f781098afc1716e07</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_PUBLIC_SHARE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819ad516c3546c3ff32fedf4a0722d143b9b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_TEMPLATES</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819ade29748ce1bc5d37e6662ea8d0c22f31</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_DIRECTORY_VIDEOS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819acde3610b2eec032f93b54863521cd20a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>USER_N_DIRECTORIES</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1d1ca7293a7a06f1d34ef3e21440b819ae59fbe2f9e59f050f71638084be185b4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FORMAT_SIZE_DEFAULT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga53f0c2b27f8ba1bca1e695397a75c673aaa2c16592d413276b5243a5b2f14c5af</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FORMAT_SIZE_LONG_FORMAT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga53f0c2b27f8ba1bca1e695397a75c673a95ca15cbe9d4b5ea304e28bc5498ce67</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FORMAT_SIZE_IEC_UNITS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga53f0c2b27f8ba1bca1e695397a75c673abf93b9978954086005fa99da714ae788</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>FORMAT_SIZE_BITS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga53f0c2b27f8ba1bca1e695397a75c673abde05d3468dbf691f7e199b5b441ae62</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>MODULE_BIND_LAZY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga502283ffbe523adf38c69905ec8640f3af7dfb341de1af451a3fc28d8c13e4593</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>MODULE_BIND_LOCAL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga502283ffbe523adf38c69905ec8640f3a61ed78ca3b7464b163e43240a4fffa96</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>MODULE_BIND_MASK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga502283ffbe523adf38c69905ec8640f3ab1bb8b50aaab642b5abfcddac8d7806b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TRAVERSE_IN_ORDER</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ggae3a70fa1e451da068323419e8c98e9a9aa7f260b474a886df2bf1aefcfc0f14b2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TRAVERSE_PRE_ORDER</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ggae3a70fa1e451da068323419e8c98e9a9abed8efe71581ccb087323f38b6807661</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TRAVERSE_POST_ORDER</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ggae3a70fa1e451da068323419e8c98e9a9a0af70e322b94dfbbfc98b100d21cef4e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TRAVERSE_LEVEL_ORDER</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>ggae3a70fa1e451da068323419e8c98e9a9a16cd819f4ab8175453f6287aeefad870</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_CASELESS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da4e6c0b8e730db041fc8d1261c2932a7f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MULTILINE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68dab11968f7c699f48954c586063dc83226</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_DOTALL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68daa30cd6e3af26544676c5c05578f3701f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_EXTENDED</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68dae4955dc52d3f93f46fa7b894689bb9dd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_ANCHORED</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da242c71a1c506054daae47559a087885d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_DOLLAR_ENDONLY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da6a311ea6eb4cd26d46bef76a4ecd70d3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_UNGREEDY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68dad3d43ecb091918275855d44bf137432c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_RAW</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da9aaaffdaa133f45d7412af35ad17b29e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_NO_AUTO_CAPTURE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da98b6d7f319fcee7ae0c1b9e8dc146869</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_OPTIMIZE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68daefe22a8d4297013ffcef77b83c40bf94</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_FIRSTLINE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da4d72c42c744da757f5b4e8760933e355</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_DUPNAMES</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68dad96b981e024568febb07d7f237950a15</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_NEWLINE_CR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da8743e2fb6fc70c8bbf53a025442a9f31</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_NEWLINE_LF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da18bf3b48001c90a1aefca35dd9bd832b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_NEWLINE_CRLF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da31810ab9b1612d3dafbb86d164ea783c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_NEWLINE_ANYCRLF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da6c4921ffcc04c53566d6bfe89fcf78b6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_BSR_ANYCRLF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da9fbe4801ca6fcae969a84c16826b9393</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_JAVASCRIPT_COMPAT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gaaaedee3e1374af9f1d66ccd34252a68da7e66bb34557aafd6de8b6119c229d9c3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_ANCHORED</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746a6d9730749c5506b89f3085ce25c80c21</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NOTBOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746ae09a3a58b8d8e052a35719b4f22f937a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NOTEOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746ab8850a97e7a6b06b1a5c97e703be2a11</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NOTEMPTY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746a0aaf0a3c6a7fae74d4a1a6255062ae91</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_PARTIAL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746ab8930fa357708487ef7a83350304dc2c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NEWLINE_CR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746ae0eb9716d96049f41f5560a215ea5dab</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NEWLINE_LF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746a51549066ff64a814d44958ce9db5243b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NEWLINE_CRLF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746ad1536133fab0dd8e25c31c0c8555b365</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NEWLINE_ANY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746acebebe55d6e1197e4a7e92a4fc4a999b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NEWLINE_ANYCRLF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746aa1a18562a24484f87f73115cb3a722c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_BSR_ANYCRLF</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746affaea7b025e947b22e7378bf0b6baf92</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_BSR_ANY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746a824f70cd3d882d3717d67325b96a9b3f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_PARTIAL_SOFT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746a69d773f5f7d17ef9b91bd43d545ae1c1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_PARTIAL_HARD</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746a1d2d11e330bc91e85a50e01445288b3f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>REGEX_MATCH_NOTEMPTY_ATSTART</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga8375c7f6797efc96929e8be89435c746aea0015d4a3887504f16321a0f960241f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_DEFAULT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dda4198b367b82bc1adf3469423da582663</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_LEAVE_DESCRIPTORS_OPEN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dda3b30d87840df513617bd468c750e52c0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_DO_NOT_REAP_CHILD</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dda8ba0abbaa6e1907446857439f454ced1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_SEARCH_PATH</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dda7d76ee852f6b00ffaef373f3d595139f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_STDOUT_TO_DEV_NULL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dda7a8c2616db1e6ef21f063652fd60872e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_STDERR_TO_DEV_NULL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dda198a2b8f3ce92dce5a1117d1c2dac345</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_CHILD_INHERITS_STDIN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26ddaeb1c843fc647e28134cd3e7fa259f285</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_FILE_AND_ARGV_ZERO</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26ddaead6dad17dda98e0196495dd11d62cd7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_SEARCH_PATH_FROM_ENVP</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26dda876ee150dd220b4808c2f9ecab5dc0f6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>SPAWN_CLOEXEC_PIPES</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga075918988c271e7fb63f1a1d083e26ddace745e1ccff2497f03ea638316abe076</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>THREAD_PRIORITY_LOW</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga9b87dca6496b6ad53baec9ca01318448a035a7bdc6a5b5eae6f644ed2605e8a37</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>THREAD_PRIORITY_NORMAL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga9b87dca6496b6ad53baec9ca01318448a6216bb25baaaca32642841ade911a92e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>THREAD_PRIORITY_HIGH</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga9b87dca6496b6ad53baec9ca01318448aef77081535e90116b203ce3b3b0fe523</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>THREAD_PRIORITY_URGENT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga9b87dca6496b6ad53baec9ca01318448a5b79355bbd59c508995af57e0ed39a94</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NOT_LOCK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a2dd111336e3b057b51ca5871795fffa4a9681fb4e85e62ba64e39a12526eaa840</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TRY_LOCK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a7441a36336ea4cdb35c0fddbf3f97b19adf6b2565785992ff637cbc453988841d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TIME_TYPE_STANDARD</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga56a2fdf6fb8599b99302868a176aac43ae6b2b23e160971f7487d630c1fa8cf70</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TIME_TYPE_DAYLIGHT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga56a2fdf6fb8599b99302868a176aac43a08bb0503339270dd7bf04c3406cf60c1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>TIME_TYPE_UNIVERSAL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga56a2fdf6fb8599b99302868a176aac43a88ad6264677876bc7203353a1cf45391</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_CONTROL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea600cfdae816c0d120e6e3e4a32d5d9cb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_FORMAT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea5b522871761887006148af4734e84875</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_UNASSIGNED</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea6e8a7e7b5ce23cd99d30f4ab7b672efd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_PRIVATE_USE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea4d8e2c9e7eb9ab4352d6e4b6699267f9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_SURROGATE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea69161af321691d504ec819bb9c19b808</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_LOWERCASE_LETTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eaab14707b2ffc2073a6d770ecd70ae321</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_MODIFIER_LETTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea7bfc1c73f50fa8c69224e0df70b0b14b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_OTHER_LETTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea146261fc855eb4e65cdfb86886bdedf7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_TITLECASE_LETTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea3f43a11337d15c6050fc1ef0e2da75b6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_UPPERCASE_LETTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea43db8de276cdf9f23e23a8661456ff4d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_SPACING_MARK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eac73f211f2caa9d82027985cb8b549cf3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_ENCLOSING_MARK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea9a7db30781bd0d0a61374fd261944e07</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_NON_SPACING_MARK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea09f4af19dd4a3d3d0f10369f8b8afda2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_DECIMAL_NUMBER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eaf93e0b2714dcd443d48e246768a8da9e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_LETTER_NUMBER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea09e6ab53938abe6c9c2d8981f137e5e3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_OTHER_NUMBER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea05027699449d2ff55d446fa7572a8c5b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_CONNECT_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea32edc36db8c13121a39dc416b22f822a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_DASH_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eab3b75b13d04b7ef056e72f798dae0e3c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_CLOSE_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea0d4f41955bed4fddc7855ce714e1f957</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_FINAL_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea90fff8c0bd976f3592629074fa3e801f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_INITIAL_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eace6196e830393b5497bfbfd6501680a0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_OTHER_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea1ded1d0a0b6e5936e8a3ecd123f66869</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_OPEN_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea14677d2ca9b5a1354f7460de17579daa</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_CURRENCY_SYMBOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eae75f8f34e79ffe86801984519eb40e6f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_MODIFIER_SYMBOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea3b6b351ca86d8095ada1d6a32e758d7a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_MATH_SYMBOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eac35f3c4aa05eca14835c22a4c6a56acf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_OTHER_SYMBOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea85c851b5804ed262ed84c2d5bc59aa1c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_LINE_SEPARATOR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46ea2a65c1eb916c613c404eea150eac93ee</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_PARAGRAPH_SEPARATOR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eac808b6d7ba1f9cbb28bc0a255578085b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_SPACE_SEPARATOR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>gadfbb414be3a4d127146fdca66dc7a46eabf9e349217923adfb3baef8135756118</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_MANDATORY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaade2215e9c2207518154a283bebb5c3b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_CARRIAGE_RETURN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa48ba653f60f909e05dd9b650970ecc1e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_LINE_FEED</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaab556cd8a4eaa5d766b3e49591ffae8b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_COMBINING_MARK</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa3f8c62e980013b2e44027ef9c34ce5c8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_SURROGATE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaa47bd54d2aef8bd0e52c07e8abbb65f9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_ZERO_WIDTH_SPACE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa37b49337ed4ecd7f53e7c9a2817d029f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_INSEPARABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa9913f639ecf34dbe62f6610fc9c3da11</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_NON_BREAKING_GLUE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaab52faa88b6578ab4cd88c3095793653</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_CONTINGENT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa2cccec32194082ea6f93db40c4af1ca5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_SPACE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaac623ed7dc2c0cabe23c2d69f4572b7bf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_AFTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa9729f705eea307bb7ccb0283a3a85093</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_BEFORE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa32422806593a1aa950f533cf6eb394a9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_BEFORE_AND_AFTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa05fc37bc6f3efcf0dc74973fb967f7c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_HYPHEN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa1074d431136b2b556b91e682eee4a189</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_NON_STARTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaeb0c44e9512fb806b9ce4991e9d50f5f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_OPEN_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaab7df43ac603e4d7b51d52d5a701e718e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_CLOSE_PUNCTUATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa80435e54ace548890b953c6395556c7e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_QUOTATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaf28d5b9cddeb8bb905fcfa829f436a2c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_EXCLAMATION</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa4ab287f55e05833854353ae861b27f5b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_IDEOGRAPHIC</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaabb30f05e59de03b80d55f021de4dd1ab</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_NUMERIC</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaacc8824bbbaf262b7563f51afce9be15</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_INFIX_SEPARATOR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaacf598d2b5eb2d0459d2339f2e8a9b237</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_SYMBOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa1bd798c1ae867ef8879f01778ee37b1e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_ALPHABETIC</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaecf3f2bfd41dbab74e897106fef322c3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_PREFIX</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa7e5a7d95bc74c01ca77bd3a3446ebae3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_POSTFIX</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa4c4fd955be2dc60284b046f8f7fae397</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_COMPLEX_CONTEXT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaae0f8fcb8bfaaddb4f30edf642b2a6146</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_AMBIGUOUS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa84ce090d6c8bf46abd148573bd0e3f78</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_UNKNOWN</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaae393ca22fb6bd8b01c1012d4e3386a04</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_NEXT_LINE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa28a02b08d3965c0ea0f6ff763a34beac</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_WORD_JOINER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa968e329ae40754bed636979d27540fed</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_HANGUL_L_JAMO</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaabfa27ce91eb258c1bd72131c857669d8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_HANGUL_V_JAMO</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaeaea498600767a8af3b41e92816faea8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_HANGUL_T_JAMO</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaabefad2b773b963104e38fe77a03281c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_HANGUL_LV_SYLLABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaccb629a2a1bae689139c8f3cc1048b31</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_HANGUL_LVT_SYLLABLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa8903e767aa9ab7445578257292d1a1e3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_CLOSE_PARANTHESIS</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaabfb13fbf5e6898e8c038bd4ade5eaa4f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_CONDITIONAL_JAPANESE_STARTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa9ccab026be2a4042b441a16dc5c393ed</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_HEBREW_LETTER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaaaddbde75b0df1eee37443c5059884f19</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_REGIONAL_INDICATOR</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaadff1a8802de9de1cec52b82a9b26f515</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_EMOJI_BASE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa2c31b8c70e7d86a680e6fc5f81b92595</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_EMOJI_MODIFIER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa0d2fbd391a22f61e75f68e872bb8ada8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>UNICODE_BREAK_ZERO_WIDTH_JOINER</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga1af1a717c84d71aa4aabc9fc77b4d0eaa8e123422d888bcb53f913413fc7a5eed</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_ALNUM</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787af7d63a99479102b5391b44f631b5f009</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_ALPHA</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787ac87947c729ac3c3f9f58b0ca28460152</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_CNTRL</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787a2e19c57ce5a6eac38d911a86cc44a2fb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_DIGIT</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787a9acd9a82d0670a3eb0377db782f48853</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_GRAPH</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787a2ecdbe5137af423fce73ff2bbb34d625</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_LOWER</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787a875d3cb7494e1548db0d37ab44d4057e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_PRINT</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787a9b1775043a8043d994c0c0ab890e86c4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_PUNCT</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787ad3416d8662560db626259013ff72c58f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_SPACE</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787a7d7a68814efba3cf3d294475123413ce</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_UPPER</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787a5ae30681069b2ab88eed13e358c08090</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>ASCII_XDIGIT</name>
      <anchorfile>group__glibmmEnums.html</anchorfile>
      <anchor>gga2e5a690ed07dfaa6f9ad9f1c57acd787ad78490a35d65839f2f06449e7e472337</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_DEFAULT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848a779b5d7aebd18e4b84c5e57ad1e72510</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_NFD</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848a81e760fdac4c57b878ba43603ed6e9d8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_DEFAULT_COMPOSE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848af8fec61972c5f6ab8b7e600db176ed06</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_NFC</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848ae3887d6a5497fb144f48348af4d0c2f8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_ALL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848a112d77bcde45ec6eb2bf2ac29bb39697</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_NFKD</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848a6dbd51b7381af7adf532faec482be46a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_ALL_COMPOSE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848abfd1d0e2d16a6ba9ef9b0855124aeeb2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type></type>
      <name>NORMALIZE_NFKC</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ga18199b64f406e397627a4e7fc799f848abf819c3bb24fbe163d47308cc4058640</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_BOOL</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a0784d542e9b53c186bba6d96c131a1b7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_BYTE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a315351b721918e130a75fa64e8f595ef</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_INT16</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a88fcc49187b1e775333edd0e31fe9503</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_UINT16</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a7e31fbcbbfdd63b923e5ba30157af2c3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_INT32</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a1c7d03f6e8a214c0c9e8f93912900803</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_UINT32</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>aea985e724e3ea31a3a0ba801ab0d34ab</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_INT64</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a9fda1870c01b8514588eaf17c1f11700</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_UINT64</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a52cc2e5d30a3707d03503dfbafba0a82</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_DOUBLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a1e01c96d6a7a33b47c0ce5d3678c3cc7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_STRING</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a5234d463a42d95bf51ed31795aa214b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_OBJECT_PATH</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>acb229115cd457c6f4c46db53179bcf09</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_SIGNATURE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a1ae362fd54a0dca4ff11dc91eb91e807</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_VARIANT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a423dc734d6f45d88da308c355e1daad5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_HANDLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a42a8f15e75bbb853c29f82b226b8524d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_UNIT</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a401be57899373ddc4ea3fa90dd082c88</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_ANY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>abb0b65abaef0c0f96b5dd53c2d41d50f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_BASIC</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>af3dd5a8ce4eea408f082ec37239f8594</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_MAYBE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>afa3c807de47227c78826fbd0c1ff1c59</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_ARRAY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a44335d30ad2929ba1cb03f6b218f61f3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_TUPLE</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ae4f961225712c4218460ed1a0d09e0bd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_DICT_ENTRY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a2351713cde6ee899e9cd5dc6792424d6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_DICTIONARY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a642324aa1ad05df695012086ea4a4ee2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_STRING_ARRAY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>aeba26de9c5d32fb0d5fd14a66279d930</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_OBJECT_PATH_ARRAY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>adfdadf7e0a33345e22924c238987272f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_BYTESTRING</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>ad20daf2fe6fa1235624d4180e949ad5b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>const VariantType</type>
      <name>VARIANT_TYPE_BYTESTRING_ARRAY</name>
      <anchorfile>namespaceGlib.html</anchorfile>
      <anchor>a046eff603c12c9414430468883cc609b</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="group">
    <name>atkmmEnums</name>
    <title>atkmm Enums and Flags</title>
    <filename>group__atkmmEnums.html</filename>
    <member kind="enumeration">
      <type></type>
      <name>Role</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga19e4dff08645ca208cdf524836a1be27</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INVALID</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a03b7adf147abb99a34364887f60e2f54</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ACCEL_LABEL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a90fb348c65faa9edba2d4b12f57362b7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ALERT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a751119ceaf56a7e1d498fd0865256db5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ANIMATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8bbdc9aa636a56d50e5b2252c4b71de1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ARROW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a4e32033a4a294decb90b75426efccd51</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CALENDAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a729cc798f3a871420edf7b84e5fce29a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CANVAS</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27acc1d1fb0dde94d186cd240de4c83fb2f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CHECK_BOX</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a99dc1127fad81abe98e54feadd8edaef</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CHECK_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6e41d9ae82e9d619d8e2007de55a0d83</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COLOR_CHOOSER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a28ea532fedc5f1492f55ee42ba0d110e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COLUMN_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac562110645a30d7ffe3f0cc2414752a6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COMBO_BOX</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a249384b8d5b79299f62b88fc0d91e5ad</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DATE_EDITOR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aed6ca916b1d54f9bf12c058473c4e80f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESKTOP_ICON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6c6f6aad475905b77817469b6bc9b04d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESKTOP_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ada71f6f6bbca69523b8f05b9798101f1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DIAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac949b07517c4f4eb51c43769daea900e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DIALOG</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a07c8c90ac361cc44215bc9a13cc9d63d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DIRECTORY_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afcf15a284444b646fed5b7a2c56f5f60</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DRAWING_AREA</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a2fa15e4f6b6410032087a98829e17904</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FILE_CHOOSER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8d2b5f26392a637571fc3b0340aba1c6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FILLER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a9577893f52a7ca0d3c8097f8c36c4117</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FONT_CHOOSER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a964762ebfbe131d0d43a531ba313a0d3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8da375d17cefb5a54b15b3d94cc28f62</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_GLASS_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6ea3843b8201512a88a5efd20252092d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_HTML_CONTAINER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a4298c2d598ded8be2c8c263882af28c8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ICON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6fe1b16f7cc09e7b2f18903658d9d3b7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_IMAGE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac2730b9c7eaf67367ac3c0f078220be4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INTERNAL_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a63411be70a6256c25661b36619f991b6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LABEL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad9d6252511d4e87c47c34e7721a64718</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LAYERED_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac9e80d237b517896ae4c6a5d1ae69812</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LIST</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a976a583ee8932ede9a6e3386404ca163</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LIST_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27acf53a383aadfd934ee44868d1b894f04</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MENU</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac2b15d7e6319620647912ebeba520ca2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MENU_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a96956fae7c290317391e196997b73962</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a44d66448a05cac51943120a980ada0c6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_OPTION_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a84919c9223cf1c1956bc63bab4a06f3f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PAGE_TAB</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a30cdee73954df268b35ad60fc7af7853</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PAGE_TAB_LIST</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7b253b6220fcacf99d5d5cde334fdfab</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PANEL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a93d64dd645e4a919bffd28187ad4d73c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PASSWORD_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac0050f6c421892b3f27d71432dc8d805</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_POPUP_MENU</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad64cf2b1b9bb4c135bc82c2d2150ce29</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PROGRESS_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0ee7ee60e2887834ed3c725e8a27e6b5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PUSH_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a893358f2d67d103974775b66973c449f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RADIO_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a063d6d55f8b92793e2f040014fce61b9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RADIO_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a8ed4fe61e40eb9110f80a643fc00be61</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ROOT_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a522edfb1bad8ea4e20cfff5b2d4a4b54</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ROW_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0673b83465635c405e96ff2319ab7768</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SCROLL_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa7dcad3ca39aa6cfe8e7e2cac8613ad6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SCROLL_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a77b4d9445e55372af979ca6e9bd3ea44</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SEPARATOR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a3c73d2fb94f28c3826c91971f105157a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SLIDER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a72284d576401425d7d9d25dc227418b8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SPLIT_PANE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a854d707133a53c61d2a7f8abd51c662a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SPIN_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ae196510d3430ed6bd20c180cc20459d7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_STATUSBAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aca33485bd1b36ab060e0ee40f0fb146f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a23a1885658083e4b711ba07e54c977a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_CELL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a37b8c0a0962de75d1c5543aee0c7f334</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_COLUMN_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab4e1a16cfa76e026959c6973b6d3065f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_ROW_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a764cac0e6c79835535c01068f3048f9b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TEAR_OFF_MENU_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0e7d46e59c365b1da54969745015f76a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TERMINAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a9a6bb25c658677bb58e1bda9828c1c2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aae92d12d274c258e1e16b02b1dfe72b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TOGGLE_BUTTON</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a3a9554aa8f05b3fd255e395a75e13a65</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TOOL_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a9e57841f611edac11ce5cb99886241ac</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TOOL_TIP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa486c34f56938cc27fa35ca7d3e08b63</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TREE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a63c6af1d80435c09ed5b450eb6604867</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TREE_TABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a16edf707b28f7c93009964498ae556d1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_UNKNOWN</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a922437fd0b6fbddbf4f89f1733b8a280</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_VIEWPORT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa0c2aa0067292f8ad5e74bf77741d3a4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_WINDOW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a2360eb9b8e8509c4002ddfee5a9d0add</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_HEADER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a1402405b5b60ac46a03ba9e1b330ee10</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FOOTER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a3c73c67b2af4e6ad007608b6087728ee</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PARAGRAPH</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad2aebfb6550f478089da3c5a999270dd</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RULER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7fb381b91ab96dafa1e6bd5895d01cb2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_APPLICATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27acbd3e3422a0c938be7d7321d3b81f368</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_AUTOCOMPLETE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27af63525acc7814e9502808813e87fa5b8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_EDITBAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad2b191ec8ae853c6dd65f4878de54122</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_EMBEDDED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afe3884c520dcfbd0e8e24d1351175401</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ENTRY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27adbdabc7fa7498302460bd8037c2789eb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CHART</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aeb0574171eab9711dcd432e4f82e1146</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_CAPTION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a642a134eed486e055b8880a60f72f4ca</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_FRAME</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a6815eb11edc3f47cc3ffe55a14c4308a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_HEADING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a78988aacdcea3f7f08a2e1d16e29cb12</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_PAGE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a1d1cd19b29d207ec9bd026ed23169425</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SECTION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a985d679f4284b48f3cb49bb2cb931a3c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_REDUNDANT_OBJECT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a18b9db38b50d1d36526a04cb839f8802</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_FORM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afcfaf66601c4630eb9d8cd52e1bb93c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LINK</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7cd3b449a443269a30a8176bd11597ff</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INPUT_METHOD_WINDOW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7087be6665736ed5626110232b72e591</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TABLE_ROW</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a85e5571d7f42590c70da2826138e10a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TREE_ITEM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0929bf66fb02ff727e9ec90ba88436a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_SPREADSHEET</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afdad04066fe7ecd1a438a07dad12984d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_PRESENTATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0e2eb5a6b3d5ec4fd7b85028ea0f9cd2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad437d1c0af8ac4382c3645b059a3c5a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_WEB</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aaf8bb5440dcefd451aecdfefbc1dd25f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DOCUMENT_EMAIL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aca847b06edcf30ffdae5714fe2403fdb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_COMMENT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aff2f2f991f22f2fec8d17a01aeb3d9c1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LIST_BOX</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a7c9ba8c94939f3cd9e897cf72be9ada3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_GROUPING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab705a38b371ef3fa9db7dbca92c868fe</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_IMAGE_MAP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a60b619fe5eee23ddb8faa812f0528426</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_NOTIFICATION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a89a5954fa09c292ed2ac5c303a44b5b9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_INFO_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27aa78f97904dd22f8c2315a2447213a17e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LEVEL_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afbd314cc3c14ca683861355c59daa65a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TITLE_BAR</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a0c8599152d2d4bab7943665ebd353c68</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_BLOCK_QUOTE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab14b366c2a0206384fb6cf098134793d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_AUDIO</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ade73b7b1b708d0426fb257524c8faea7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_VIDEO</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ade1aadbc70a285548c4986763c910341</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DEFINITION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad542b7a01f095909915e229d7287cfe9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_ARTICLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27abf754dd34add6748625086310d05dea6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LANDMARK</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a06a285cfa19f9d1d2bd6f82c91145591</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LOG</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a803f7511f98ed1955b1cfc0e16e4fb7b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MARQUEE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27afb44f84d3bfab6a6881a1462e5296696</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MATH</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a5c18a5acfa9b97641452acd8537280be</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_RATING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ad0a9063c6d3bf4f279625a0b72cb33ae</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_TIMER</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a698ad4a75016d000d920378982f8b3f9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESCRIPTION_LIST</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a1e4ef7c6a1153bcb26700ea2527b5967</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESCRIPTION_TERM</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a4f281b31a47f58f26928c4722dc16ce3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_DESCRIPTION_VALUE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a07d8d327bcd58a01a91003c6c9e42594</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_STATIC</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a734952c6ba04ec0162ed3b1d952d6c64</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MATH_FRACTION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27a34023fd8176925431aa304cc1f701619</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_MATH_ROOT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27af60918fa4c53179e6126f0ca3bac1610</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SUBSCRIPT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27accad65056cdd6186b30f8105740cfd2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_SUPERSCRIPT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ab49bc13be45410b0201b3c56c3afd16c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>ROLE_LAST_DEFINED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga19e4dff08645ca208cdf524836a1be27ac2a78ab956bc9edb48ef9c20e7fa4db2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>StateType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga2b925d92032639815edcfd9b0f53d15e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_INVALID</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaf38c9a5ee701bd869fa693dde077ae94</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ACTIVE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea3b96a8572f1fb31ba171e8eb76d44434</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ARMED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea36f02ef2ddb01fcb26d33caa4896c7be</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_BUSY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea3d81e4407381a35205154904c27d4b07</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_CHECKED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea6a36533b9c0bcc4e1f34f461ff8cd137</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_DEFUNCT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaf15f11d7b48b1119169c80789a3ea6c9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_EDITABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea35fcaac7746569ade7f7386832603de7</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ENABLED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea74d7172d6fd23d38d5627c00276c39fc</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_EXPANDABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eafc4c8c22b95953a4d65ee30827873c6c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_EXPANDED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaef89a6238be3b2983589cea2c8e79eee</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_FOCUSABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaa0021f2c26dba14838aff2420c8f4470</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_FOCUSED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea2a4d25fbbc37ecbdd0568fd1df6908a5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_HORIZONTAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea19eec6e9b6278a938a80a69c845768bb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ICONIFIED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea854aab00b1fcfaeb21a3e3166e54bb71</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MODAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea54d686d0481e36bdc4fcddf87631691b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MULTI_LINE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea3cab9f3ac425aa5ba0c67e59f8794d43</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MULTISELECTABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea590b7d91649336348d28f6f55c18cfbd</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_OPAQUE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea9e46ab4b9bce571c2513a3be9b6b9604</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_PRESSED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea245197daf9437f95382b79396f48792a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_RESIZABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead336da6c742fc4ce3531aa97b74841f6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SELECTABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea8184260e7b2f204a489a1c80d9a1939b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SELECTED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eacc45152c44f7cf29087c66bf17583410</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SENSITIVE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae0c53804b335dd7d55e1a3ddbe12d76f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SHOWING</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea471306798894af3cd14ee19ec3aaef90</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SINGLE_LINE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eab7dc583652460e80737563afad54c48c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_STALE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea0b03f4269d42f6413c7087181b8a37c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_TRANSIENT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eabb54a2722b9b213a699f35a09195afca</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_VERTICAL</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eab9027e2efcc01b4aac8deb30e34fc0aa</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_VISIBLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea6aa787a91d66a1c8fea75c196febfc43</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_MANAGES_DESCENDANTS</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea5895f35295aeaa7cc86de41bf7cb2517</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_INDETERMINATE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae4b19682debcbeada8e9061b033bbd22</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_TRUNCATED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead1f2cb1d7770bb2c4549ef5b998cf21c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_REQUIRED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eaeea37ea980f7cb90a79eed520bc635e5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_INVALID_ENTRY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead23e93d50443d9192b13fc22aae4487a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SUPPORTS_AUTOCOMPLETION</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea728f19b8503f125626d40de2694eda0f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_SELECTABLE_TEXT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eafbd1e0653faaedf8c0f2195155c53a71</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_DEFAULT</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae6515e887af6dba27f3440f4077246a6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_ANIMATED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15eae1676a444f17d437c39d2ea259bb0b30</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_VISITED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea4250cdc6e143fa21ffb33f5393b5d60b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_CHECKABLE</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea7d7bf124cb47822589dbde80870b7b27</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_HAS_POPUP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea791201a6f5afbb03e45201a659051265</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_HAS_TOOLTIP</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea459fd9dbe770234f46622b1a69171588</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_READ_ONLY</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ead4b696e61543f7a90b38237b1437efc1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>STATE_LAST_DEFINED</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gga2b925d92032639815edcfd9b0f53d15ea65bb8311dba662b7de5ca0fc6ab4ffe4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>CoordType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga6c71d0aa1d2e5c4917bafa3f12c811c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>XY_SCREEN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga6c71d0aa1d2e5c4917bafa3f12c811c2afa31df89eb2fbb9862967e3a3e3fadb4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>XY_WINDOW</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga6c71d0aa1d2e5c4917bafa3f12c811c2a1ee9258286acd6ac79e7f649de697715</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>Layer</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_INVALID</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8ab1d38350db6a7d49bea9a42e36bc7cad</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_BACKGROUND</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8aaffd8c676fe1537d7601867324ac6bfa</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_CANVAS</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a11e333012ad71145d9526591f0ba1a2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_WIDGET</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a2563fc72826b830d266cab03826549e3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_MDI</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a17f0de0715b1e8ace446e4e07153bffb</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_POPUP</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a2db25c44dee98b88362a3f32ff011923</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_OVERLAY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a9a37fc12a0d7a09e7250f6e548d6d739</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>LAYER_WINDOW</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga880a348fd3270c7bca549113c38501a8a6909bfdaa74f71006dbdb879e36c147a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>RelationType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_NULL</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a08ff14d1f85fc39fb99f92958408849c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_CONTROLLED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ac85893b44b851917a24b02e56694bfdd</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_CONTROLLER_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5af442a9c480c217aa87cf5fe9cbc4fad2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_LABEL_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a9073f39a105ccb105ce72d670488fe1d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_LABELLED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a48f99753886b49bab1794cb261ad2850</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_MEMBER_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aed90e228ea7ab72f851bab3d36449247</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_NODE_CHILD_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a0bbdde6e6e1a4ddc9a88c73b71002a8d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_FLOWS_TO</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ad83a326fd91c165e6fc2746898ebb6ec</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_FLOWS_FROM</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aff86319aa82ffa35a10597fed2413a44</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_SUBWINDOW_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a24dca51b60973eae594a5ce636395871</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_EMBEDS</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aad0bb4e210e16a8b8c9e5f0294c77ea6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_EMBEDDED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ac2955b63a70bb1e0cec6cf1ad6f0a7d4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_POPUP_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5af7a0b46b2b9046910913117fe7312b88</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_PARENT_WINDOW_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5aacf63b7fdd12da9af60ab5b1ddc8b5c6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_DESCRIBED_BY</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a071dce0a4eb78f24ab64d4e536da85f4</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_DESCRIPTION_FOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5ac3fc29e5101dcc1f22cdf01fbf90d6df</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_NODE_PARENT_OF</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a4c4c308f2b1bd5b2f112b13cb25e08d6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>RELATION_LAST_DEFINED</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga83c3f0442ea6f73e32064b0caab555e5a1809f2d94842f78a8e5387698ec73915</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>BuiltinTextAttribute</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_INVALID</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca6623d891e6bd2208c9eefd24818fd607</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_LEFT_MARGIN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca2b960ba196c7b30805302a5eb8e68c67</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_RIGHT_MARGIN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca90a6fc151df2620a05ffd9e6b11a14f6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_INDENT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca7e2423b00c02750ec2e9bf3bb2a2746b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_INVISIBLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca6a62c8d4ed9e0b3576781f0bf438600b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_EDITABLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca686a97eac5e7b2441b9d135eaa8aedd9</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_PIXELS_ABOVE_LINES</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca25f48005c0ca8297fa1af4cf0a93004b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_PIXELS_BELOW_LINES</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cac138d55030e45b2f69988c22c2e59dd6</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_PIXELS_INSIDE_WRAP</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca01fc024ae13e08378337ee5706a05c2c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_BG_FULL_HEIGHT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cadd0551cc3e6eb5f8a7d92715e1abbc1a</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_RISE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca07e54f14a00a3eee2ef2673e9c2c76d0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_UNDERLINE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca0bc049631db42b5d8592517d7808eeb1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_STRIKETHROUGH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cab48dfe09328fa8944e100265a607bf97</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_SIZE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca4ccfa24b0cd1e7606d3efa12e83c43a2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_SCALE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cac419a4005306997b96d132f97677e155</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_WEIGHT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca65ff75007b1066c6db020eda58fef272</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_LANGUAGE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca9806ae08818a64eb9b0a40d102229365</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_FAMILY_NAME</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca35b3400077ff53359e96eaaa237434f0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_BG_COLOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca5fd2c74fdd6398aef3a9ef6cd72a9ee3</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_FG_COLOR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca506f4979837e29ac43cd8260e5847f15</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_BG_STIPPLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca81533acc5938e4457a9321362b640d1f</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_FG_STIPPLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caccbd21662832e81f410f32e3651b4cd2</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_WRAP_MODE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca7dc78afcf3ee43e478994e2d8e6aefa5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_DIRECTION</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca6f45667975ba8eea4816f669136365f5</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_JUSTIFICATION</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caa8a04cd3c92075079045b4a1c6052f81</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_STRETCH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389ca4af53be9eb1140dfb427727811799f42</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_VARIANT</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389cae216ca5822aaa755c0d1b9e8783200ee</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_STYLE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caf4302d1b05ef86d456d9eaf72455490b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_ATTR_LAST_DEFINED</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga570689825e833a547382a99c553e389caa9b6ba53580dc243040d4089cbe25b6c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TextBoundary</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5b</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_CHAR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5baa9d3c2bb0b1bff614d192bf1ed511dff</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_WORD_START</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba5ba2088bb55054a4174b592a97d41eda</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_WORD_END</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba86ac904b652515f20264f9303e4f368c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_SENTENCE_START</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba15fd2598f02f559dd94740177fdda0f1</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_SENTENCE_END</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba17b884b049388ee37e2a69935f909f1e</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_LINE_START</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5bae63453a52227ecbc0e9b77ce1e93b1b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_BOUNDARY_LINE_END</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>gace98a3ea010fe92c359fa4bcd4aaea5ba4d06f3a051104a36c6f81e47c79220b0</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TextClipType</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_NONE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102acd3a8a23ccb6e486855b6853c6bf4d16</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_MIN</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102a762a6ea026e37dd76fc600156ce3f32c</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_MAX</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102a9323a443fd8fd1d053e7e9eceef49c31</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_CLIP_BOTH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga0b25ada8fc7111dfed7f6550a6874102a381a32f59dd65a5dc8338990a1ada36d</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>TextGranularity</name>
      <anchorfile>group__atkmmEnums.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157ac</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_CHAR</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157aca053c97eb7d13c76c54e081cfe2bcdc41</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_WORD</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157aca56f7354a85f01443476596b29dc94800</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_SENTENCE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157acab4ecfefd5237e4d4147f399d391d35ad</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_LINE</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157acaf639e9ee84883727da0ea0ec19a670ed</anchor>
      <arglist></arglist>
    </member>
    <member kind="enumvalue">
      <name>TEXT_GRANULARITY_PARAGRAPH</name>
      <anchorfile>namespaceAtk.html</anchorfile>
      <anchor>ga19fa84ea5f7567a68ebe784b9d3157acaaae88db1a99725557feee9364023655d</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="page">
    <name>index</name>
    <title>atkmm Reference Manual</title>
    <filename>index</filename>
    <docanchor file="index" title="Introduction and History">intro</docanchor>
    <docanchor file="index" title="Contents">contents</docanchor>
    <docanchor file="index" title="General Features">general</docanchor>
    <docanchor file="index" title="Argument Promotion">promotion</docanchor>
    <docanchor file="index" title="NaN Arguments">NaN</docanchor>
    <docanchor file="index" title="Implementation">impl</docanchor>
    <docanchor file="index" title="Testing">testing</docanchor>
    <docanchor file="index" title="General Bibliography">bibliography</docanchor>
    <docanchor file="index" title="Description">description</docanchor>
    <docanchor file="index" title="Features">features</docanchor>
    <docanchor file="index" title="Basic Usage">basics</docanchor>
    <docanchor file="index" title="Using Meson">meson</docanchor>
    <docanchor file="index" title="Using Autotools">autotools</docanchor>
    <docanchor file="index" title="Using CMake">cmake</docanchor>
    <docanchor file="index" title="Scope of Documentation">scope</docanchor>
  </compound>
</tagfile>
