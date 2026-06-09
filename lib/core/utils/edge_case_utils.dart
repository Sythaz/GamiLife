// System Utility: edge_case_utils.dart
import 'dart:math';

class StatDecayCalculator {
  /// Evaluates the Stat Decay penalty after retroactive offline Ghost Days.
  /// 
  /// [CRITICAL DOMAIN RULE]: Stat decay is not just cosmetic. 
  /// Reducing stats directly causes high-tier, Stat-Gated quests 
  /// (Tier A & S) to become IMMEDIATELY LOCKED.
  /// 
  /// [SLUMP MODE DECAY FREEZE]: Decay can ONLY run for a maximum of 4 consecutive 
  /// Ghost Days. On Day 4, Slump Mode activates and stats are frozen in amber to 
  /// prevent mathematical bricking of the save file.
  static Map<String, int> calculateDecay(Map<String, int> currentStats, {required int ghostDaysCount, double decayRate = 0.15}) {
    // 1. MAX DECAY LIMIT & AMBER FREEZE:
    final effectiveDecayDays = min(ghostDaysCount, 4);
    
    // 2. CALCULATE DECAY FOR ALLOWED DAYS
    final compoundedDecayMultiplier = pow(1.0 - decayRate, effectiveDecayDays);
    
    final newStats = <String, int>{};
    currentStats.forEach((key, value) {
      newStats[key] = (value * compoundedDecayMultiplier).floor();
    });
    
    // The repository layer MUST re-evaluate QuestPoolModel.requiredStatsJson 
    // against these newStats.
    return newStats;
  }
}
