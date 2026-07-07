class AuthorProfile {
  final String id;
  final String name;
  final String intro;
  final List<String> tags;

  const AuthorProfile({
    required this.id,
    required this.name,
    required this.intro,
    required this.tags,
  });
}

class AuthorsMetadata {
  static const List<AuthorProfile> authors = [
    AuthorProfile(
      id: 'prabhu',
      name: 'A.C. Bhaktivedanta Swami Prabhupada',
      intro: 'Founder-Acharya of ISKCON and one of the world\'s most influential teachers of Krishna Bhakti. His Bhagavad Gita commentary emphasizes devotional service and presents Krishna as the Supreme Personality of Godhead.',
      tags: ['English Translation', 'English Commentary'],
    ),
    AuthorProfile(
      id: 'sankar',
      name: 'Sri Adi Shankaracharya',
      intro: 'The great philosopher who consolidated Advaita Vedanta and taught the non-dual nature of Brahman. His Bhagavad Gita commentary is among the most authoritative and influential in Hindu philosophy.',
      tags: ['English Translation', 'Hindi Translation', 'Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'raman',
      name: 'Sri Ramanujacharya',
      intro: 'Founder of Vishishtadvaita Vedanta, teaching qualified non-dualism centered on loving devotion to Lord Narayana. His Gita commentary highlights surrender, devotion, and divine grace.',
      tags: ['English Translation', 'Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'madhav',
      name: 'Sri Madhvacharya',
      intro: 'Founder of the Dvaita Vedanta school, teaching the eternal distinction between the individual soul and the Supreme Lord. His Bhagavad Gita interpretation emphasizes devotion and divine grace.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'chinmay',
      name: 'Swami Chinmayananda',
      intro: 'Founder of Chinmaya Mission and one of the most influential modern teachers of Vedanta. His Bhagavad Gita commentary combines scriptural depth with practical guidance for everyday life.',
      tags: ['Hindi Commentary'],
    ),
    AuthorProfile(
      id: 'siva',
      name: 'Swami Sivananda',
      intro: 'Founder of the Divine Life Society and a renowned spiritual master whose teachings combine yoga, devotion, meditation, and selfless service. His Gita commentary is practical and inspiring.',
      tags: ['English Translation', 'English Commentary'],
    ),
    AuthorProfile(
      id: 'rams',
      name: 'Swami Ramsukhdas',
      intro: 'One of the most beloved modern Hindi commentators on the Bhagavad Gita. His explanations are simple, practical, and deeply spiritual, making the Gita accessible to millions.',
      tags: ['Hindi Translation', 'Hindi Commentary'],
    ),
    AuthorProfile(
      id: 'tej',
      name: 'Swami Tejomayananda',
      intro: 'Former Global Head of Chinmaya Mission and a respected Vedanta teacher. His commentary presents timeless wisdom in a concise, modern, and easy-to-understand manner.',
      tags: ['Hindi Translation'],
    ),
    AuthorProfile(
      id: 'purohit',
      name: 'Shri Purohit Swami',
      intro: 'A spiritual teacher and translator who collaborated in bringing Indian philosophy to Western readers. His translation emphasizes simplicity, spirituality, and universal understanding.',
      tags: ['English Translation'],
    ),
    AuthorProfile(
      id: 'san',
      name: 'Dr. S. Sankaranarayan',
      intro: 'A distinguished Sanskrit scholar and translator known for presenting classical scriptures in accurate modern English. His work balances linguistic precision with philosophical depth.',
      tags: ['English Translation'],
    ),
    AuthorProfile(
      id: 'adi',
      name: 'Swami Adidevananda',
      intro: 'A revered monk of the Ramakrishna Order known for his clear English translations of Vedantic scriptures. His commentary faithfully presents the teachings of Sri Ramanuja\'s Vishishtadvaita philosophy in a modern and accessible style.',
      tags: ['English Translation'],
    ),
    AuthorProfile(
      id: 'gambir',
      name: 'Swami Gambirananda',
      intro: 'A senior monk of the Ramakrishna Order renowned for precise English translations of Advaita Vedanta texts. His works are widely respected for their accuracy and scholarly approach.',
      tags: ['English Translation'],
    ),
    AuthorProfile(
      id: 'anand',
      name: 'Sri Anandgiri',
      intro: 'A renowned Advaita Vedanta scholar and commentator best known for his explanatory notes on Adi Shankaracharya\'s works. His writings clarify subtle philosophical concepts through traditional interpretation.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'abhinav',
      name: 'Sri Abhinav Gupta',
      intro: 'One of India\'s greatest philosopher-mystics and the foremost teacher of Kashmir Shaivism. His interpretation blends non-dual philosophy, spirituality, and deep metaphysical insight.',
      tags: ['English Translation', 'Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'jaya',
      name: 'Sri Jayatirtha',
      intro: 'One of the greatest philosophers of the Dvaita Vedanta tradition established by Madhvacharya. His detailed commentaries systematically explain dualistic philosophy with exceptional logical rigor.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'vallabh',
      name: 'Sri Vallabhacharya',
      intro: 'Founder of the Shuddhadvaita (Pure Non-dualism) school and the Pushti Marg tradition. His teachings emphasize loving devotion and the grace of Lord Krishna.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'ms',
      name: 'Sri Madhusudan Saraswati',
      intro: 'A celebrated Advaita Vedanta scholar who beautifully integrated non-dual philosophy with deep devotion to Lord Krishna. His writings remain classics of Indian spiritual literature.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'srid',
      name: 'Sri Sridhara Swami',
      intro: 'A highly respected medieval commentator whose devotional interpretations greatly influenced later Vaishnava traditions. His writings balance philosophy with heartfelt devotion.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'dhan',
      name: 'Sri Dhanpati',
      intro: 'A respected traditional Sanskrit commentator whose writings closely follow classical Vedantic interpretation. His work preserves the original philosophical intent of the scriptures.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'venkat',
      name: 'Vedanta Desika (Venkatanatha)',
      intro: 'One of the greatest philosophers and poets of the Sri Vaishnava tradition. His writings defend and expand Ramanuja\'s Vishishtadvaita philosophy with remarkable scholarship and devotion.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'puru',
      name: 'Sri Purushottamji',
      intro: 'A traditional Vedantic scholar whose commentary explains the Bhagavad Gita through classical Sanskrit reasoning. His work focuses on preserving authentic scriptural interpretation.',
      tags: ['Sanskrit Commentary'],
    ),
    AuthorProfile(
      id: 'neel',
      name: 'Sri Neelkanth',
      intro: 'A respected traditional commentator known for preserving the classical Sanskrit interpretation of Hindu scriptures. His explanations focus on authentic scriptural meaning and philosophical clarity.',
      tags: ['Sanskrit Commentary'],
    ),
  ];
}
