use super::ToModule;
use crate::{
    colors::{Color, Style},
    icons::Icon,
};
use std::{fmt, process::Command, time::Duration};

pub struct GpuMemory {
    usage: Option<f32>,
    minimum_digits: usize,
    decimal_places: usize,
}

fn read_usage() -> Option<f32> {
    let output = Command::new("nvidia-smi")
        .args([
            "--query-gpu=memory.used,memory.total",
            "--format=csv,noheader,nounits",
        ])
        .output()
        .ok()?;

    if !output.status.success() {
        return None;
    }

    let stdout = String::from_utf8(output.stdout).ok()?;
    let (used, total) = stdout.trim().lines().next()?.split_once(',')?;
    let used: f32 = used.trim().parse().ok()?;
    let total: f32 = total.trim().parse().ok()?;

    (total > 0.0).then_some((used / total) * 100.0)
}

impl GpuMemory {
    pub fn new(minimum_digits: usize, decimal_places: usize) -> Self {
        Self {
            usage: read_usage(),
            minimum_digits,
            decimal_places,
        }
    }

    pub fn try_new(minimum_digits: usize, decimal_places: usize) -> Option<Self> {
        read_usage().map(|usage| Self {
            usage: Some(usage),
            minimum_digits,
            decimal_places,
        })
    }
}

impl fmt::Display for GpuMemory {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self.usage {
            Some(usage) => write!(
                f,
                "{:0width$.prec$}%",
                usage,
                width = self.minimum_digits,
                prec = self.decimal_places
            ),
            None => write!(f, "N/A"),
        }
    }
}

impl ToModule for GpuMemory {
    fn style(&self) -> Style {
        Style::new_with_fg(Color::Magenta)
    }

    fn icon(&self) -> Option<Icon> {
        Some(Icon::Gpu)
    }

    fn update(&mut self) {
        self.usage = read_usage();
    }

    fn next_render_time(&self) -> Option<Duration> {
        Some(Duration::from_secs_f32(7.5))
    }

    fn include(&self) -> bool {
        self.usage.is_some()
    }
}
