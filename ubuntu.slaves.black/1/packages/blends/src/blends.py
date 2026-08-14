'''A module to handle Debian Pure Blends tasks, modelled after apt.package.

The examples use the following sample tasks file:

>>> sample_task = """Format: https://blends.debian.org/blends/1.1
... Task: Education
... Install: true
... Description: Educational astronomy applications
...  Various applications that can be used to teach astronomy.
...  .
...  This is however incomplete.
...
... Recommends: celestia-gnome | celestia-glut, starplot
...
... Recommends: gravit
... WNPP: 743379
... Homepage: http://gravit.slowchop.com/
... Pkg-Description: Visually stunning gravity simulator
...  Gravit is a free, visually stunning gravity simulator.
...  .
...  You can spend endless time experimenting with various
...  configurations of simulated universes.
... Why: Useful package
... Remark: Entered Debian in 2014
...
... Suggests: sunclock, xtide
... """
>>> with open('education', 'w') as fp:
...     nbytes = fp.write(sample_task)
'''
import io
import os
import itertools
import re
import shutil
from debian.deb822 import Deb822


class Blend:
    '''Representation of a Debian Pure Blend.
    '''
    def __init__(self, basedir='.'):
        with open(os.path.join(basedir, 'debian', 'control.stub'),
                  encoding="UTF-8") as fp:
            self.control_stub = Deb822List(Deb822.iter_paragraphs(fp))

        self.name = self.control_stub[0]['Source']
        '''Full (package) name of the blend (``debian-astro``)'''

        self.short_name = re.sub(r'^debian-', '', self.name)
        '''Short name of the blend (``astro``)'''

        self.title = 'Debian ' + self.short_name.capitalize()
        '''Blends title (``Debian Astro``)'''

        base_deps = ["${misc:Depends}"]

        self.prefix = self.short_name
        '''Prefix for tasks (``astro``)'''

        for pkg in self.control_stub[1:]:
            p = pkg['Package'].split('-', 1)
            if len(p) > 1 and p[1] == 'tasks':
                self.prefix = p[0]
                base_deps.append("{Package} (= ${{source:Version}})"
                                 .format(**pkg))
                break

        try:
            with open(os.path.join(basedir, 'config', 'control'),
                      encoding="UTF-8") as fp:
                self.control_stub.append(Deb822(fp))
                base_deps.append("{}-config (= ${{source:Version}})"
                                 .format(self.prefix))
        except IOError:
            pass

        self.tasks = []
        '''``Task`` list'''
        for name in sorted(filter(lambda n: n[-1] != '~',
                                  os.listdir(os.path.join(basedir, 'tasks')))):
            with open(os.path.join(basedir, 'tasks', name),
                      encoding="UTF-8") as fp:
                task = Task(self, name, fp, base_deps=base_deps)
            self.tasks.append(task)

    def update(self, cache):
        '''Update from cache

        :param cache: ``apt.Cache`` like object

        This adds the available versions to all dependencies. It
        updates descriptions, summaries etc. available to all
        BaseDependencies in all tasks.

        Instead of using ``update()``, also the ``+=`` operator can be used.

        '''
        for task in self.tasks:
            task += cache

    def __iadd__(self, cache):
        self.update(cache)
        return self

    @property
    def all(self):
        '''All Base Dependencies of this task
        '''
        return list(itertools.chain(*(t.all for t in self.tasks)))

    def fix_dependencies(self):
        '''Fix the dependencies according to available packages

        This lowers all unavailable ``recommended`` dependencies to
        ``suggested``.
        '''
        missing = []
        for task in self.tasks:
            missing += task.fix_dependencies()
        return missing

    def gen_control(self):
        '''Return the task as list of ``Deb822`` objects suitable for
        ``debian/control``
        '''
        tasks = list(filter(lambda task: task.is_metapackage, self.tasks))

        # Create the special 'all' task recommending all tasks that
        # shall be installed by default
        all_task = Task(
            self, "all",
            '''Description: Default selection of tasks for {task.title}
 This package is part of the {task.title} Pure Blend and installs all
 tasks for a default installation of this blend.'''.format(task=self),
            base_deps=['${misc:Depends}'])
        for task in tasks:
            if task.install:
                all_task.recommends.append(Dependency("Recommends",
                                                      task.package_name))
            else:
                all_task.suggests.append(Dependency("Suggests",
                                                    task.package_name))
        if len(all_task.recommends) > 0:
            tasks.insert(0, all_task)

        return Deb822List(self.control_stub
                          + [task.gen_control() for task in tasks])

    def gen_task_desc(self, udeb=False):
        '''Return the task as list of ``Deb822`` objects suitable for
        ``blends-task.desc``
        '''
        tasks = list(filter(lambda task: task.is_metapackage and task.is_leaf,
                            self.tasks))

        header = [Deb822({
            'Task': self.name,
            'Relevance':  '7',
            'Section': self.name,
            'Description': '{} Pure Blend\n .'.format(self.title),
        })] if not udeb else []
        return Deb822List(header + [task.gen_task_desc(udeb)
                                    for task in tasks])


class Task:
    '''Representation of a Blends task. Modelled after apt.package.Version.

    The Version class contains all information related to a
    specific package version of a blends task.

    :param blend: ``Blend`` object, or Blend name

    :param name: Name of the task

    :param sequence: ``str`` or ``file`` containing the ``Deb822``
                     description of the task

    :param base_deps: List of dependencies to add to the task (``str``)

    When the header does not contain a line

    ``Format: https://blends.debian.org/blends/1.1``

    then the ``Depends`` priorities will be lowered to ``Recommends``
    when read.

    Example:

    >>> with open('education') as fp:
    ...     task = Task('debian-astro', 'education', fp)
    >>> print(task.name)
    education
    >>> print(task.package_name)
    astro-education
    >>> print(task.description)
    Various applications that can be used to teach astronomy.
    <BLANKLINE>
    This is however incomplete.
    >>> print(task.summary)
    Educational astronomy applications
    >>> print(task.section)
    metapackages
    >>> print(task.architecture)
    all
    >>> for p in task.all:
    ...     print(p.name)
    celestia-gnome
    celestia-glut
    starplot
    gravit
    sunclock
    xtide

    '''
    def __init__(self, blend, name, sequence, base_deps=None):
        if isinstance(blend, str):
            self.blend = blend
            '''Blend name'''

            self.prefix = blend[len('debian-'):] \
                if blend.startswith('debian-') else blend
            '''Metapackage prefix'''
        else:
            self.blend = blend.name
            self.prefix = blend.prefix

        self.name = name
        '''Task name'''

        self.content = Deb822List(Deb822.iter_paragraphs(sequence))
        '''Deb822List content of the task'''

        self.header = self.content[0]
        '''Deb822 header'''

        self.base_deps = base_deps or []
        '''Base dependencies'''

        # Check for the format version, and upgrade if not actual
        self.format_upgraded = False
        '''``True`` if the format was upgraded from an older version'''

        if 'Format' in self.header:
            self.format_version = self.header['Format'].strip() \
                .rsplit('/', 1)[-1]
        else:
            self.format_version = '1'
        if self.format_version.split('.') < ['1', '1']:
            self.content = Task.upgrade_from_1_0(self.content)
            self.format_upgraded = True

        # Create package dependencies
        dep_types = ["Depends", "Recommends", "Suggests"]
        dep_attrs = ["dependencies", "recommends", "suggests"]
        for dep_type, dep_attr in zip(dep_types, dep_attrs):
            setattr(self, dep_attr, list(itertools.chain(
                *(list(Dependency(dep_type, s.strip(), par)
                       for s in par.get(dep_type, '').split(",") if s)
                  for par in self.content[1:]))))
        self.enhances = [
            Dependency('Enhances', s.strip(), self.header)
            for s in self.header.get('Enhances', '').split(",") if s
        ]

    @property
    def install(self):
        '''``True`` if the task is installed as a default package
        '''
        return self.header.get("Install") == "true"

    @property
    def index(self):
        '''``True`` if the task shall appear in the tasks index in the
        web senitel
        '''
        return self.header.get("index", "true") == "true"

    @property
    def is_leaf(self):
        return self.header.get("leaf", "true") == "true"

    @property
    def is_metapackage(self):
        '''``True`` if the tasks has a Debian metapackage
        '''
        return self.header.get("metapackage", "true") == "true"

    @property
    def package_name(self):
        return '{task.prefix}-{task.name}'.format(task=self)

    @property
    def description(self):
        '''Return the formatted long description.
        '''
        desc = self.header.get("Pkg-Description",
                               self.header.get("Description"))
        if not desc:
            return None
        else:
            return "\n".join(line[1:] if line != ' .' else ''
                             for line in desc.split("\n")[1:])

    @property
    def summary(self):
        '''Return the short description (one line summary).
        '''
        desc = self.header.get("Pkg-Description",
                               self.header.get("Description"))
        return desc.split('\n')[0] if desc else None

    @property
    def section(self):
        '''Return the section of the package.
        '''
        return 'metapackages'

    @property
    def architecture(self):
        '''Return the architecture of the package version.
        '''
        return self.header.get('Architecture', 'all')

    @property
    def tests(self):
        '''Return all tests for this task when included in tasksel
        '''
        tests = dict((key.split('-', 1)[1], value)
                     for key, value in self.header.items()
                     if key.startswith('Test-'))
        if self.install:
            tests['new-install'] = 'mark show'
        return tests

    @property
    def all(self):
        '''All Base Dependencies of this task
        '''
        return list(itertools.chain(
            *itertools.chain(self.dependencies,
                             self.recommends,
                             self.suggests)))

    def gen_control(self):
        '''Return the task as ``Deb822`` object suitable for ``debian/control``

        >>> with open('education') as fp:
        ...     task = Task('debian-astro', 'education', fp)
        >>> print(task.gen_control().dump())
        Package: astro-education
        Section: metapackages
        Architecture: all
        Recommends: celestia-gnome | celestia-glut,
                    gravit,
                    starplot
        Suggests: sunclock,
                  xtide
        Description: Educational astronomy applications
         Various applications that can be used to teach astronomy.
         .
         This is however incomplete.
        <BLANKLINE>
        '''
        d = Deb822()
        d['Package'] = self.package_name
        d['Section'] = self.section
        d['Architecture'] = self.architecture
        if self.dependencies or self.base_deps:
            d['Depends'] = ",\n         ".join(sorted(
                self.base_deps
                + list(set(d.rawstr for d in self.dependencies))
            ))
        if self.recommends:
            d['Recommends'] = ",\n            ".join(sorted(
                set(d.rawstr for d in self.recommends)
            ))
        if self.suggests:
            d['Suggests'] = ",\n          ".join(sorted(
                set(d.rawstr for d in self.suggests)
            ))
        d['Description'] = self.summary + '\n ' + \
            "\n ".join(self.description.replace("\n\n", "\n.\n").split("\n"))
        return d

    def gen_task_desc(self, udeb=False):
        '''Return the task as ``Deb822`` object suitable for ``blends-task.desc``.

        :parameter udeb: if ``True``, generate ```blends-task.desc``
                         suitable for udebs

        >>> with open('education') as fp:
        ...     task = Task('debian-astro', 'education', fp)
        >>> print(task.gen_task_desc().dump())
        Task: astro-education
        Parent: debian-astro
        Section: debian-astro
        Description: Educational astronomy applications
         Various applications that can be used to teach astronomy.
         .
         This is however incomplete.
        Test-new-install: mark show
        Key:
         astro-education
        <BLANKLINE>

        '''
        d = Deb822()
        d['Task'] = self.package_name
        if not udeb:
            d['Parent'] = self.blend
        d['Section'] = self.blend
        d['Description'] = self.summary + '\n ' + \
            "\n ".join(self.description.replace("\n\n", "\n.\n").split("\n"))
        if udeb:
            d['Relevance'] = '10'
        if self.enhances:
            d['Enhances'] = ', '.join(sorted(d.name for d in itertools.chain(
                *self.enhances)))
        for key, value in self.tests.items():
            d['Test-' + key] = value
        d['Key'] = '\n {}'.format(self.package_name)
        return d

    def update(self, cache):
        '''Update from cache

        This adds the available versions to all dependencies. It updates
        descriptions, summaries etc. available to all BaseDependencies.

        :param cache: ``apt.Cache`` like object

        Instead of using ``update()``, also the ``+=`` operator can be used:

        >>> import apt
        >>> with open('education') as fp:
        ...     task = Task('debian-astro', 'education', fp)
        >>> dep = task.recommends[1][0]
        >>> print(dep.name + ": ", dep.summary)
        starplot:  None
        >>> task += apt.Cache()
        >>> print(dep.name + ": ", dep.summary)
        starplot:  3-dimensional perspective star map viewer
        '''
        for dep in self.all:
            pkg = cache.get(dep.name)
            if pkg is not None:
                dep.target_versions += pkg.versions
            if hasattr(cache, 'get_providing_packages'):
                for pkg in cache.get_providing_packages(dep.name):
                    dep.target_versions += pkg.versions

    def __iadd__(self, cache):
        self.update(cache)
        return self

    def fix_dependencies(self):
        '''Fix the dependencies according to available packages

        This lowers all unavailable ``recommended`` dependencies to
        ``suggested``.

        >>> import apt
        >>> with open('education') as fp:
        ...     task = Task('debian-astro', 'education', fp)
        >>> for dep in task.recommends:
        ...     print(dep.rawstr)
        celestia-gnome | celestia-glut
        starplot
        gravit
        >>> for dep in task.suggests:
        ...     print(dep.rawstr)
        sunclock
        xtide
        >>> task += apt.Cache()
        >>> missing = task.fix_dependencies()
        >>> for dep in task.recommends:
        ...     print(dep.rawstr)
        starplot
        gravit
        >>> for dep in task.suggests:
        ...     print(dep.rawstr)
        sunclock
        xtide
        celestia-gnome | celestia-glut
        '''
        missing = list()
        for recommended in self.recommends[:]:
            suggested = Dependency("Suggests")
            for dep in recommended[:]:
                if len(dep.target_versions) == 0:
                    recommended.remove(dep)
                    suggested.append(dep)
                    missing.append(dep)
            if len(recommended) == 0:
                self.recommends.remove(recommended)
            if len(suggested) > 0:
                self.suggests.append(suggested)
        return missing

    @staticmethod
    def upgrade_from_1_0(content):
        header = [("Format", "https://blends.debian.org/blends/1.1")]
        header += list(filter(lambda x: x[0] != "Format", content[0].items()))
        res = [dict(header)]
        for p in content[1:]:
            q = []
            for key, value in p.items():
                if key == 'Depends' and 'Recommends' not in p:
                    key = 'Recommends'
                # Remove backslashes, which are not DEB822 compliant
                value = re.sub(r'\s*\\', '', value)
                q.append((key, value))
            res.append(dict(q))
        return Deb822List(res)


class Dependency(list):
    '''Represent an Or-group of dependencies.

    Example:

    >>> with open('education') as fp:
    ...     task = Task('debian-astro', 'education', fp)
    >>> dep = task.recommends[0]
    >>> print(dep.rawstr)
    celestia-gnome | celestia-glut
    '''

    def __init__(self, rawtype, s=None, content=None):
        super(Dependency, self).__init__(BaseDependency(bs.strip(), content)
                                         for bs in (s.split("|") if s else []))
        self.rawtype = rawtype
        '''The type of the dependencies in the Or-group'''

    @property
    def or_dependencies(self):
        return self

    @property
    def rawstr(self):
        '''String represenation of the Or-group of dependencies.

        Returns the string representation of the Or-group of
        dependencies as it would be written in the ``debian/control``
        file.  The string representation does not include the type of
        the Or-group of dependencies.
        '''
        return ' | '.join(bd.rawstr for bd in self)

    @property
    def target_versions(self):
        '''A list of all Version objects which satisfy this Or-group of deps.
        '''
        return list(itertools.chain(bd.target_versions for bd in self))


class BaseDependency:
    '''A single dependency.

    Example:

    >>> with open('education') as fp:
    ...     task = Task('debian-astro', 'education', fp)
    >>> dep = task.recommends[2][0]
    >>> print(dep.rawstr)
    gravit
    >>> print(dep.wnpp)
    743379
    >>> print(dep.homepage)
    http://gravit.slowchop.com/
    >>> print(dep.description)
    Gravit is a free, visually stunning gravity simulator.
    <BLANKLINE>
    You can spend endless time experimenting with various
    configurations of simulated universes.
    >>> print(dep.summary)
    Visually stunning gravity simulator
    '''

    def __init__(self, s, content=None):
        r = re.compile(r'([a-z0-9][a-z0-9+-\.]+)')
        m = r.match(s)
        if m is None or m.string != s:
            raise ValueError('"{}" is not a valid package name'.format(s))
        self.name = s
        self.content = content or dict()
        self.target_versions = []

    def _get_from_target_versions(self, key):
        for v in self.target_versions:
            if v.package.name == self.name:
                return getattr(v, key)

    @property
    def rawstr(self):
        '''String represenation of the dependency.

        Returns the string representation of the dependency as it
        would be written in the ``debian/control`` file.  The string
        representation does not include the type of the dependency.
        '''
        return self.name

    @property
    def wnpp(self):
        '''The WNPP bug number, if available, or None
        '''
        return self.content.get("WNPP")

    @property
    def homepage(self):
        '''Return the homepage for the package.
        '''
        return self._get_from_target_versions("homepage") or \
            self.content.get("Homepage")

    @property
    def description(self):
        '''Return the formatted long description.
        '''
        desc = self._get_from_target_versions("description")
        if desc is not None:
            return desc
        desc = self.content.get("Pkg-Description",
                                self.content.get("Description"))
        if desc:
            return "\n".join(line[1:] if line != ' .' else ''
                             for line in desc.split("\n")[1:])

    @property
    def summary(self):
        '''Return the short description (one line summary).
        '''
        summary = self._get_from_target_versions("summary")
        if summary:
            return summary

        desc = self.content.get("Pkg-Description",
                                self.content.get("Description"))
        if desc:
            return desc.split('\n')[0]

    @property
    def why(self):
        return self.content.get("Why")

    @property
    def remark(self):
        return self.content.get("Remark")


class Deb822List(list):
    '''A list of ``Deb822`` paragraphs
    '''
    def __init__(self, paragraphs):
        list.__init__(self, (p if isinstance(p, Deb822) else Deb822(p)
                             for p in paragraphs))

    def dump(self, fd=None, encoding=None, text_mode=False):
        '''Dump the the contents in the original format

        If ``fd`` is ``None``, returns a ``str`` object. Otherwise,
        ``fd`` is assumed to be a ``file``-like object, and this
        method will write the data to it instead of returning an
        ``str`` object.

        If ``fd`` is not ``None`` and ``text_mode`` is ``False``, the
        data will be encoded to a byte string before writing to the
        file.  The encoding used is chosen via the encoding parameter;
        None means to use the encoding the object was initialized with
        (utf-8 by default).  This will raise ``UnicodeEncodeError`` if
        the encoding can't support all the characters in the
        ``Deb822Dict`` values.

        '''
        if fd is None:
            fd = io.StringIO()
            return_string = True
        else:
            return_string = False

        for p in self:
            p.dump(fd, encoding, text_mode)
            fd.write("\n")

        if return_string:
            return fd.getvalue()


def aptcache(release=None, srcdirs=['/etc/blends']):
    '''Open and update a (temporary) apt cache for the specified distribution.

    :param release: Distribution name

    :param srcdirs: List of directories to search for
        ``sources.list.<<release>>``

    If the distribution is not given, use the system's cache without update.
    '''
    import tempfile
    import apt

    if release is None:
        return apt.Cache()
    rootdir = tempfile.mkdtemp()
    try:
        os.makedirs(os.path.join(rootdir, 'etc', 'apt'))
        shutil.copytree('/etc/apt/trusted.gpg.d',
                        os.path.join(rootdir, 'etc', 'apt', 'trusted.gpg.d'))
        for src_dir in srcdirs:
            sources_list = os.path.join(src_dir,
                                        'sources.list.{}'.format(release))
            if os.path.exists(sources_list):
                shutil.copy(sources_list,
                            os.path.join(rootdir, 'etc/apt/sources.list'))
                break
        else:
            raise OSError("sources.list not found in " + str(srcdirs))
        cache = apt.Cache(rootdir=rootdir, memonly=True)
        cache.update()
        cache.open()
    finally:
        shutil.rmtree(rootdir)
    return cache


def uddcache(packages, release, components=['main'], **db_args):
    '''Create a ``dict`` from UDD that is roughly modelled after ``apt.Cache``.

    The ``dict`` just resolves the version number and archs for the packages.
    For performance reasons, an initial package list needs to be given.

    :param release: Distribution name
    :param packages: Initial package list
    :param db_args: UDD connection parameters

    ``Provided`` dependencies are integrated in the returned ``dict``.
    '''
    import collections
    import psycopg2

    pkgtuple = tuple(set(p.name for p in packages))

    componenttuple = tuple(components)

    Package = collections.namedtuple('Package',
                                     ('name', 'versions',))
    Version = collections.namedtuple('Version',
                                     ('package', 'architecture', 'version'))

    # To make the SELECT statements easier, we create a virtual view
    # of the "packages" table that is restricted to the release and
    # the component(s)
    pkg_view_stmt = '''
    CREATE TEMPORARY VIEW pkg
    AS SELECT packages.package,
           packages.version,
           packages.architecture,
           packages.provides
    FROM packages, releases
    WHERE packages.release=releases.release
        AND (releases.release=%s  OR releases.role=%s)
        AND packages.component IN %s;
    '''

    # Since the "provides" are in a comma separated list, we create a
    # normalized view
    provides_view_stmt = '''
    CREATE TEMPORARY VIEW provides
    AS SELECT DISTINCT
        package,
        version,
        architecture,
        regexp_split_to_table(regexp_replace(provides,
                                             E'\\\\s*\\\\([^)]*\\\\)',
                                             '', 'g'),
                              E',\\\\s*') AS provides
    FROM pkg;
    '''

    # Query all packages that have one of the specified names either as
    # package name, or as one of the provides
    query_stmt = '''
    SELECT package,
           version,
           architecture,
           provides
    FROM pkg
    WHERE package IN %s
    UNION
    SELECT package,
           version,
           architecture,
           provides
    FROM provides
    WHERE provides IN %s;
    '''

    with psycopg2.connect(**db_args) as conn:
        cursor = conn.cursor()
        cursor.execute(pkg_view_stmt, (release, release, componenttuple))
        cursor.execute(provides_view_stmt)
        cursor.execute(query_stmt, (pkgtuple, pkgtuple))

        cache = dict()
        for package, version, arch, provides in cursor:
            p = cache.setdefault(package, Package(package, []))
            p.versions.append(Version(p, arch, version))
            if provides:
                for prv in provides.split(','):
                    pp = cache.setdefault(prv, Package(package, []))
                    pp.versions.append(Version(p, arch, version))
        return cache
